# Viren Infrastructure

Terraform code để dựng hạ tầng AWS cho dự án Viren. Gồm 2 phần độc lập, apply riêng (mỗi folder tự có state/provider của mình).

## `infrastruture/` — Backend (API + Agents)

Dựng 1 EC2 (Ubuntu 22.04) chạy backend qua Docker Compose, đứng sau Application Load Balancer có HTTPS.

- **EC2**: cài Docker + nginx, chạy container qua `user_data.sh` (sinh file `.env`, `docker-compose.yml`, và chạy các script trong `scripts/`).
- **ALB + target groups**: route `api.<domain>` → port 5297 (API chính), `ai.<domain>` → port 8000 (agents).
- **ACM + Route53**: tự xin và validate chứng chỉ TLS, tạo DNS record cho `api.<domain>` và `ai.<domain>`.
- **Security group**: mở 22 (SSH), 1433 (MSSQL), 5433 (Postgres) theo `allowed_ssh_cidr`; app port chỉ nhận traffic từ ALB.

File cần tự chuẩn bị trước khi `terraform apply` (đã bị `.gitignore`, không có trong repo):
- `terraform.tfvars` — set `domain_name`, `allowed_ssh_cidr`, ...
- `viren-ec2-key` / `viren-ec2-key.pub` — SSH keypair cho EC2
- `viren.env` — biến môi trường backend (DB, JWT, AWS, PayOS, SMTP, OpenAI, ...)

## `infrastructureFE/` — Frontend (SPA)

Host static SPA (React/Vite build) qua S3 + CloudFront.

- **S3 bucket**: lưu file build, chặn truy cập public trực tiếp (chỉ CloudFront đọc qua OAC).
- **CloudFront**: phân phối SPA, fallback 403/404 về `index.html` (hỗ trợ client-side routing).
- **ACM (us-east-1) + Route53**: chứng chỉ TLS và DNS cho domain gốc và `www.<domain>`.

File cần tự chuẩn bị trước khi apply: `terraform.tfvars` (set `domain_name`).

## Lưu ý bảo mật

Các file state, biến nhạy cảm và private key (`*.tfstate`, `*.tfvars`, `*.env`, `viren-ec2-key`, `*.pem`, ...) đã được đưa vào `.gitignore` và **không được commit**. Không tự ý bỏ các dòng này khỏi `.gitignore`.
