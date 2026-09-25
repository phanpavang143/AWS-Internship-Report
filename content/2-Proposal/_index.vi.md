---
title: "Xây dựng Website Thương mại điện tử trên AWS"
date: 2026-08-30
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Xây dựng Website Thương mại điện tử trên AWS
## Kiến trúc ứng dụng thương mại điện tử hiệu quả, an toàn và dễ mở rộng trên AWS

### 1. Tóm tắt điều hành

Dự án xây dựng một website thương mại điện tử sử dụng Spring Boot 3.5, Java 25 và mô hình server-side rendering với Spring MVC/JSP. Ứng dụng được container hóa bằng Docker và triển khai trên Amazon ECS Fargate, kết hợp Amazon RDS MySQL, Amazon S3, Amazon SQS và các dịch vụ giám sát của AWS. Kiến trúc được định hướng theo mô hình modular monolith, giúp giữ độ đơn giản của ứng dụng nhưng vẫn có khả năng mở rộng ngang khi số lượng người dùng tăng. Các điểm cần cải thiện trọng tâm gồm quản lý database bằng Terraform/RDS, connection pooling, session dùng chung, xử lý order bất đồng bộ và tối ưu chi phí mạng. Giải pháp đề xuất ưu tiên tính ổn định, bảo mật, khả năng mở rộng và kiểm soát chi phí trước khi xem xét tách thành microservices.

---

### 2. Tuyên bố vấn đề

#### 2.1. Vấn đề hiện tại

##### 1. Database chưa được quản lý hoàn toàn bằng hạ tầng mã hóa

Database hiện phải được cung cấp bên ngoài Terraform, khiến môi trường triển khai chưa hoàn toàn reproducible và khó đồng bộ giữa development, staging và production. Khi cần khôi phục hoặc dựng lại môi trường, đội vận hành phải thực hiện thêm các bước thủ công. Việc thiếu RDS được quản lý bằng IaC cũng làm giảm khả năng chuẩn hóa backup, security group, subnet group và secret. Đây là điểm cần ưu tiên khắc phục trước khi mở rộng hệ thống.

##### 2. Kết nối database chưa phù hợp với việc scale nhiều ECS task

Ứng dụng đang sử dụng `DriverManagerDataSource`, không cung cấp connection pool như HikariCP. Khi ECS service tăng số task, mỗi task có thể tạo và đóng nhiều kết nối trực tiếp tới MySQL, gây overhead và làm tăng nguy cơ chạm giới hạn connection của database. Tình trạng này có thể ảnh hưởng đến latency khi traffic tăng đột biến. Vì vậy, connection pooling cần được đưa vào cấu hình chuẩn của Spring Boot.

##### 3. Giỏ hàng phụ thuộc vào HttpSession

Cart hiện được lưu trong `HttpSession`, nên trạng thái người dùng phụ thuộc vào task ECS đang phục vụ request. Khi chạy nhiều task, hệ thống phải dùng sticky session hoặc một session store dùng chung để tránh mất trạng thái. Sticky session là giải pháp chuyển tiếp nhưng làm giảm tính stateless của ứng dụng. Với website thương mại điện tử, lưu cart theo `user_id` trong database phù hợp hơn vì cart có thể được duy trì giữa nhiều thiết bị và nhiều phiên đăng nhập.

##### 4. Luồng SQS chưa phản ánh đầy đủ nghiệp vụ đơn hàng

SQS hiện mới nhận event thêm hoặc xóa sản phẩm khỏi cart và chưa trở thành nền tảng cho một order flow hoàn chỉnh. Điều này khiến khả năng xử lý bất đồng bộ của hệ thống chưa được khai thác cho các tác vụ như tạo đơn, gửi thông báo hoặc cập nhật trạng thái. Khi quy mô tăng, các tác vụ nền cần được tách khỏi request đồng bộ để giảm thời gian phản hồi. Kiến trúc worker dùng ECS hoặc Lambda có thể xử lý các event theo cơ chế retry và dead-letter queue.

#### 2.2. Giải pháp đề xuất

Giải pháp chuyển ứng dụng sang mô hình modular monolith chạy trên ECS Fargate, sử dụng RDS MySQL làm database được quản lý và S3/CloudFront cho ảnh sản phẩm. Spring Boot được cấu hình HikariCP để quản lý connection pool, đồng thời cart được chuyển sang database hoặc Redis tùy yêu cầu về session/cache. SQS được sử dụng cho các tác vụ bất đồng bộ và worker riêng xử lý order/event. Toàn bộ hạ tầng được quản lý bằng Terraform, kết hợp CloudWatch và CloudTrail để giám sát và audit.

##### Kiến trúc chia làm 3 luồng xử lý độc lập

**1. Luồng người dùng (Web/App)**  
Người dùng truy cập hệ thống qua CloudFront và ALB trước khi request đến ECS Spring Boot. Luồng này xử lý đăng nhập, hồ sơ, danh mục, sản phẩm và giỏ hàng. Dữ liệu nghiệp vụ được đọc/ghi vào RDS, trong khi ảnh được phân phối từ S3 qua CloudFront.

**2. Luồng quản trị (Admin)**  
Admin truy cập cùng ứng dụng nhưng được Spring Security kiểm tra quyền `ADMIN`. Luồng này quản lý sản phẩm, danh mục, khách hàng và các dữ liệu vận hành. Các thao tác ghi được kiểm soát bằng authorization và ghi nhận log để phục vụ audit.

**3. Luồng xử lý bất đồng bộ (Order/Events)**  
Các sự kiện cần xử lý nền được đưa vào SQS thay vì giữ request HTTP chờ hoàn tất. Worker chạy bằng ECS hoặc Lambda đọc queue, xử lý nghiệp vụ và cập nhật trạng thái. Cơ chế retry và Dead-Letter Queue giúp cô lập message lỗi và tăng độ tin cậy.

#### 2.3. Lợi ích và hoàn vốn đầu tư (ROI)

Giải pháp giúp giảm các điểm nghẽn vận hành bằng cách chuyển database sang dịch vụ managed, bổ sung connection pooling và loại bỏ sự phụ thuộc trực tiếp của cart vào một ECS task. Chi phí được kiểm soát thông qua Fargate sizing phù hợp, auto scaling, CloudWatch retention ngắn cho môi trường demo và VPC Endpoint để giảm lưu lượng qua NAT Gateway. Giá trị ROI nên được đánh giá theo tổng chi phí sở hữu (TCO), thời gian vận hành thủ công, downtime và khả năng phục vụ thêm người dùng thay vì chỉ tính chi phí hạ tầng. Với môi trường demo hoặc traffic thấp, có thể bắt đầu ở quy mô nhỏ và mở rộng theo số liệu thực tế.

---

### 3. Kiến trúc giải pháp

#### 3.1. Sơ đồ kiến trúc tổng thể

![Sơ đồ kiến trúc tổng thể](/images/2-Proposal/Sodokientruc.png)

> Sơ đồ trên minh họa kiến trúc mục tiêu: Client → CloudFront → ALB → ECS Fargate; ECS kết nối RDS MySQL, Redis và S3; các event được đưa vào SQS để worker xử lý; CloudWatch và CloudTrail cung cấp khả năng quan sát và audit; Terraform quản lý hạ tầng.

#### 3.2. Chi tiết các luồng xử lý chính trong kiến trúc

##### Luồng 1 — Người dùng và website

* **Truy cập hệ thống:** Browser gửi request tới CloudFront, sau đó request động được chuyển tới ALB và ECS Fargate. Cách triển khai này tạo lớp entry point thống nhất và cho phép scale nhiều task.
* **Xử lý nghiệp vụ:** Spring MVC/JSP render giao diện phía server và Spring Security kiểm tra authentication/authorization. Hibernate/JPA thực hiện thao tác dữ liệu với RDS MySQL thông qua connection pool.
* **Ảnh sản phẩm:** Ảnh được upload lên S3 và có thể phân phối qua CloudFront. Việc tách object storage khỏi container giúp giảm dung lượng image và tránh mất dữ liệu khi task được thay thế.

##### Luồng 2 — Quản trị Admin

* **Xác thực và phân quyền:** Admin đăng nhập thông qua Spring Security và được kiểm tra role `ADMIN`. Các endpoint quản trị chỉ được phép truy cập khi authorization thành công.
* **Quản lý dữ liệu:** Admin có thể tạo, sửa, xóa sản phẩm, danh mục và quản lý khách hàng. Các thao tác được lưu vào RDS và có thể được theo dõi thông qua application log.
* **Upload hình ảnh:** Ảnh sản phẩm được lưu trên S3 thay vì filesystem của container. Điều này phù hợp với môi trường Fargate vì task có thể bị thay thế hoặc scale theo nhu cầu.

##### Luồng 3 — Xử lý bất đồng bộ

* **Đưa event vào queue:** Ứng dụng gửi các event nghiệp vụ cần xử lý nền tới SQS. Request chính không phải chờ worker hoàn tất toàn bộ tác vụ.
* **Worker xử lý:** ECS worker hoặc Lambda đọc message, xử lý nghiệp vụ và cập nhật trạng thái vào RDS. Các message lỗi có thể được retry và chuyển sang Dead-Letter Queue sau số lần thất bại quy định.
* **Giám sát:** Kết quả xử lý và lỗi được ghi nhận vào CloudWatch. Queue depth, error rate và processing latency có thể được dùng làm cơ sở để tạo alarm.

#### 3.3. Các dịch vụ AWS mà dự án sử dụng

##### Amazon ECS Fargate
ECS Fargate chạy container Spring Boot mà không cần quản lý máy chủ EC2. Service có thể tăng hoặc giảm số task theo tải và phù hợp với mô hình deployment container.

##### Application Load Balancer (ALB)
ALB tiếp nhận HTTP/HTTPS traffic và phân phối request tới các ECS task khỏe mạnh. Health check giúp loại task không hoạt động khỏi luồng traffic.

##### Amazon RDS for MySQL
RDS cung cấp MySQL managed với backup, monitoring và các tùy chọn availability. Database nên đặt trong private subnet và security group chỉ cho phép ECS truy cập cổng 3306.

##### Amazon S3
S3 lưu trữ ảnh sản phẩm và các object tĩnh. Object storage tách biệt với lifecycle của container nên phù hợp với môi trường scale ngang.

##### Amazon CloudFront
CloudFront phân phối ảnh và nội dung cacheable từ edge location. Việc kết hợp CloudFront với S3 giúp giảm latency và giảm tải trực tiếp lên ứng dụng.

##### Amazon SQS
SQS làm message queue cho các event và tác vụ xử lý nền. Queue giúp tách request web khỏi worker và hỗ trợ retry khi consumer gặp lỗi.

##### Amazon ElastiCache for Redis
Redis có thể được dùng làm shared session store hoặc cache dữ liệu thường xuyên truy cập. Trong môi trường demo, Redis có thể chưa cần thiết và chỉ nên triển khai khi có nhu cầu thực tế.

##### Amazon CloudWatch
CloudWatch thu thập log, metric và alarm của ứng dụng cũng như hạ tầng. Đây là nền tảng chính để theo dõi CPU, memory, error rate, latency và queue depth.

##### AWS CloudTrail
CloudTrail ghi nhận các hoạt động API và thay đổi tài nguyên AWS. Dữ liệu audit giúp hỗ trợ điều tra sự cố và kiểm soát hoạt động quản trị.

##### AWS Lambda
Lambda có thể xử lý các event SQS nhẹ mà không cần duy trì worker server. Đây là lựa chọn phù hợp cho workload không liên tục và có thời gian xử lý ngắn.

##### AWS NAT Gateway và VPC Endpoint
NAT Gateway cung cấp outbound connectivity từ private subnet nhưng có chi phí cố định và chi phí dữ liệu. VPC Endpoint cho S3 và SQS có thể giảm traffic qua NAT và phù hợp với mục tiêu tối ưu chi phí.

##### Terraform
Terraform mô tả VPC, ECS, RDS, IAM, S3, SQS và các tài nguyên liên quan dưới dạng Infrastructure as Code. Điều này giúp môi trường có thể tái tạo, review và version-control.

---

### 4. Kĩ thuật triển khai

#### 4.1. Các giai đoạn triển khai

##### Giai đoạn 1 — Chuẩn hóa ứng dụng và hạ tầng nền

* Chuyển datasource sang HikariCP, loại bỏ phụ thuộc vào `hibernate.hbm2ddl.auto=update` trong production và chuẩn hóa cấu hình qua environment variables/secrets.
* Provision RDS MySQL, S3, SQS, ECS, IAM, networking và security group bằng Terraform.

##### Giai đoạn 2 — Stateless và scale ngang

* Chuyển cart khỏi `HttpSession` sang database hoặc Redis để các ECS task có thể phục vụ request độc lập.
 Thiết lập ECS service, ALB health check, desired count và auto scaling theo CPU/request.

##### Giai đoạn 3 — Tối ưu hiệu năng và chi phí

* Đưa ảnh qua S3 + CloudFront và sử dụng VPC Endpoint cho S3/SQS khi phù hợp.
* Thiết lập CloudWatch alarm, log retention và sizing Fargate/RDS theo traffic thực tế.

##### Giai đoạn 4 — Mở rộng nghiệp vụ

* Hoàn thiện order flow và worker xử lý bất đồng bộ qua SQS.
* Chỉ tách Order/Inventory/Search thành service riêng khi metrics chứng minh cần scale hoặc triển khai độc lập.

#### 4.2. Yêu cầu kỹ thuật và bảo mật

##### 1. Identity và phân quyền
Spring Security phải kiểm soát rõ `USER` và `ADMIN`, đồng thời áp dụng least privilege cho IAM role. Không lưu AWS access key hoặc database password trực tiếp trong source code.

##### 2. Bảo mật dữ liệu
RDS nên nằm trong private subnet và chỉ nhận kết nối từ security group của ECS. Secret được quản lý bằng AWS Secrets Manager và dữ liệu truyền qua HTTPS/TLS.

##### 3. Tối ưu hiệu suất
HikariCP phải được cấu hình phù hợp với số lượng ECS task và giới hạn connection của RDS. Cache chỉ nên được bổ sung sau khi có metric chứng minh database hoặc request latency là bottleneck.

##### 4. Giám sát và nhật ký
CloudWatch được dùng để tập trung log, metric và alarm, trong khi CloudTrail phục vụ audit hoạt động AWS. Log cần tránh chứa password, session identifier hoặc dữ liệu nhạy cảm của người dùng.

---

### 5. Lộ trình và mốc triển khai

| Mốc | Thời gian dự kiến | Kết quả chính |
|---|---|---|
| M1 — Chuẩn bị | Tuần 1–2 | Chuẩn hóa Spring Boot, HikariCP, Docker và Terraform |
| M2 — Managed Database | Tuần 3–4 | RDS MySQL, Secrets Manager, private networking |
| M3 — ECS Production-ready | Tuần 5–6 | ECS Fargate, ALB, health check, autoscaling |
| M4 — Storage & Async | Tuần 7–8 | S3/CloudFront, SQS và worker |
| M5 — Observability | Tuần 9–10 | CloudWatch, CloudTrail, alarms, log retention |
| M6 — Tối ưu & đánh giá | Tuần 11–12 | Load test, cost review, security review và tài liệu hóa |
| M7 — Mở rộng | Sau tháng 8 | Redis, read replica hoặc tách service khi có số liệu chứng minh |

---

### 6. Ước tính ngân sách

> Các con số dưới đây là **ước tính tham khảo** cho môi trường nhỏ/demo hoặc production nhỏ, không phải báo giá cố định. Chi phí thực tế phụ thuộc Region, loại instance, lưu lượng, request, storage, thời gian chạy và cấu hình backup.

| Dịch vụ AWS | Cấu hình / Quy mô ước tính | Chi phí ước tính / Tháng (USD) |
|---|---|---:|
| ECS Fargate | Web + Worker, khoảng 2 task nhỏ | ~20–80 |
| RDS MySQL | Single-AZ, instance nhỏ | ~20–50 |
| S3 + CloudFront | Khoảng 50 GB storage + traffic thấp | ~10–30 |
| SQS | Khoảng 1 triệu request/tháng | ~1–5 |
| ElastiCache Redis | Node nhỏ, chỉ khi cần | ~15–40 |
| CloudWatch + CloudTrail | Log/metrics quy mô nhỏ | ~10–25 |
| NAT Gateway | 1 NAT Gateway | ~45–60+ |
| **Tổng tham khảo** | Môi trường nhỏ, traffic thấp | **~121–290+** |

Đối với development/demo, có thể giảm đáng kể chi phí bằng cách chạy một ECS task, dùng RDS nhỏ, retention CloudWatch 7 ngày, không triển khai Redis khi chưa cần và tắt các môi trường không sử dụng ngoài giờ.

---

### 7. Đánh giá rủi ro

#### 7.1. Ma trận rủi ro và chiến lược giảm thiểu

| Rủi ro tiềm ẩn | Mức độ ảnh hưởng | Xác suất | Chiến lược giảm thiểu |
|---|---|---|---|
| RDS quá tải hoặc cạn connection | Cao | Trung bình | Dùng HikariCP, giới hạn pool, theo dõi RDS metrics và load test |
| Mất dữ liệu hoặc lỗi backup | Cao | Thấp | Automated backup, retention phù hợp, kiểm tra restore định kỳ |
| Session/cart không nhất quán khi scale | Cao | Trung bình | Lưu cart theo user trong DB hoặc dùng Redis session |
| Chi phí NAT Gateway tăng | Trung bình | Trung bình | VPC Endpoint cho S3/SQS, theo dõi Data Processing và Cost Explorer |
| ECS task lỗi khi traffic tăng | Cao | Trung bình | ALB health check, autoscaling, CloudWatch alarm |
| Lộ secret hoặc credential | Rất cao | Thấp | Secrets Manager, IAM least privilege, không hard-code secret |
| Message SQS xử lý thất bại | Trung bình | Trung bình | Retry policy, visibility timeout và Dead-Letter Queue |
| `hibernate.hbm2ddl.auto=update` gây thay đổi schema ngoài kiểm soát | Cao | Trung bình | Dùng migration tool như Flyway/Liquibase trong production |
| Phức tạp hóa do microservices quá sớm | Trung bình | Trung bình | Duy trì modular monolith và chỉ tách service dựa trên metrics |

---

### 8. Kết quả kỳ vọng

#### 8.1. Cải tiến kỹ thuật đột phá

Kiến trúc chuyển từ mô hình phụ thuộc vào database và session thủ công sang nền tảng managed, stateless và có khả năng scale ngang. ECS Fargate, RDS, S3, SQS và CloudWatch tạo thành các lớp hạ tầng có trách nhiệm rõ ràng, giảm sự phụ thuộc vào máy chủ và thao tác thủ công. Việc chuẩn hóa Terraform, connection pooling, asynchronous processing và observability tạo nền tảng để hệ thống phát triển mà không phải tái cấu trúc toàn bộ kiến trúc.

#### 8.2. Tối ưu hóa chi phí triệt để

Chi phí được kiểm soát bằng cách lựa chọn Fargate/RDS theo workload thực tế, giới hạn log retention và tránh triển khai Redis hoặc các dịch vụ nâng cao khi chưa có nhu cầu. VPC Endpoint cho các dịch vụ AWS phù hợp có thể giảm lượng traffic đi qua NAT Gateway. Auto Scaling giúp tài nguyên tăng theo nhu cầu thay vì duy trì cấu hình lớn cố định.

#### 8.3. Giá trị dài hạn

Kiến trúc tạo nền tảng để mở rộng số lượng người dùng, sản phẩm và transaction mà vẫn giữ mô hình vận hành tương đối đơn giản. Khi hệ thống tăng trưởng, có thể bổ sung Redis, read replica, worker riêng hoặc Search service mà không cần chuyển đổi toàn bộ ứng dụng. Quan trọng hơn, modular monolith giúp dự án giữ tốc độ phát triển trong giai đoạn đầu và chỉ trả thêm chi phí vận hành khi có nhu cầu scale thực tế.

---

## Kết luận

Kiến trúc mục tiêu phù hợp cho dự án là **Spring Boot modular monolith trên ECS Fargate, RDS MySQL làm database chính, S3/CloudFront cho ảnh, SQS cho xử lý bất đồng bộ và CloudWatch/CloudTrail cho observability và audit**. Redis được xem là thành phần bổ sung khi hệ thống cần shared session hoặc cache, thay vì mặc định triển khai ngay từ đầu. Microservices chỉ nên được áp dụng khi có bằng chứng về nhu cầu scale độc lập, ownership hoặc vòng đời triển khai riêng. Cách tiếp cận theo từng giai đoạn giúp dự án cân bằng giữa khả năng mở rộng, bảo mật, độ phức tạp vận hành và chi phí.

## Phụ lục — Nguyên tắc kiến trúc

1. **Managed first:** ưu tiên RDS, S3, SQS và Fargate thay vì tự quản lý máy chủ.
2. **Stateless first:** ECS task không giữ trạng thái nghiệp vụ quan trọng trong local filesystem hoặc session cục bộ.
3. **Scale from evidence:** chỉ thêm Redis, read replica hoặc microservices khi metrics cho thấy nhu cầu.
4. **Security by default:** private subnet, least-privilege IAM, Secrets Manager, HTTPS và audit logging.
5. **Infrastructure as Code:** Terraform là nguồn khai báo chuẩn cho các tài nguyên AWS.
