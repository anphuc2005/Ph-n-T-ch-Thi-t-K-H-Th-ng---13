# CineMan — JSP / Servlet

CineMan tập trung vào hai luồng: quản lý thêm phim và khách hàng đặt vé trực tuyến. Dự án dùng Java 17+, JSP/Servlet Jakarta, Tomcat 10.1, Maven và MySQL. Khách có thể xem phim/lịch chiếu công khai; cần tài khoản để đặt vé.

## Chạy local

1. Cài JDK 17+, Maven, MySQL và Tomcat 10.1.
2. Với CSDL mới, chạy `schema.sql`, `seed.sql`, rồi migration V2 để tạo các bảng của luồng đặt vé. `schema.sql` đã chứa sẵn các cột V3/V4, nên không chạy lại hai migration đó; sau V2, ghi nhận phần schema đã có bằng lệnh `INSERT INTO schema_versions(version) VALUES(3),(4);`. Seed dùng dữ liệu demo và không chạy lại trên cùng CSDL.
3. Với CSDL CineMan đang chạy V3, backup trước rồi áp dụng migration V4 duy nhất:

   ```sh
   /usr/local/mysql/bin/mysqldump -u root -p --single-transaction --no-tablespaces cineman > cineman-before-v4.sql
   /usr/local/mysql/bin/mysql -u root -p cineman < src/main/resources/db/migrations/V4__customer_order_contact.sql
   ```

   V4 thêm số điện thoại vào hồ sơ customer và lưu tên/email/điện thoại chụp tại thời điểm mua trên đơn online; các đơn cũ được điền tên/email từ tài khoản nếu có. Xác nhận `SELECT * FROM schema_versions` có version 4. Không chạy lại script sau khi đã áp dụng.
4. Sao chép `config/cineman.xml.example` vào `$CATALINA_BASE/conf/Catalina/localhost/cineman.xml`, cấu hình tài khoản DB local trong bản sao ngoài repository, và cài MySQL Connector/J trong `$CATALINA_BASE/lib/`.
5. Build WAR bằng `mvn -DskipTests package` từ thư mục `src/`, chép `target/cineman.war` vào `$CATALINA_BASE/webapps/`, rồi khởi động Tomcat.
6. Mở `http://localhost:8080/cineman/app`.

## Tài khoản demo

Mật khẩu chung `Demo@12345`, chỉ dùng với dữ liệu bài tập:

| Vai trò | Email | Truy cập |
|---|---|---|
| Quản lý | `manager@cineman.local` | Thêm phim; cấu hình phụ phòng và lịch chiếu |
| Khách hàng | `customer@cineman.local` | Duyệt phim, đặt vé, xem/in vé và biên nhận |

## Luồng chính

- **Thêm phim:** quản lý nhập tên, thể loại, thời lượng, mô tả, poster; ngày khởi chiếu, phân loại độ tuổi và trailer là tùy chọn. Poster JPEG/PNG tối đa 5 MB được preview trước khi gửi. Lịch chiếu được thiết lập riêng trong mục **Cấu hình rạp**.
- **Đặt vé online:** khách duyệt phim → chọn suất → đăng nhập → chọn ghế → kiểm tra tổng tiền → tạo đơn và giữ ghế tối đa 5 phút → thanh toán mô phỏng → xem/in vé và biên nhận. Trang thanh toán demo có lựa chọn thành công hoặc thất bại. Không có tiền thật bị trừ và không gọi VNPAY.
- **Thông tin customer:** tại bước đặt vé, tên và email lấy từ tài khoản; khách nhập số điện thoại liên hệ. Số điện thoại được lưu vào hồ sơ và bản chụp tên/email/điện thoại được lưu cùng đơn, hiển thị trên bước thanh toán và hóa đơn.
- Ghế hết hạn/thanh toán thất bại không được phát hành vé; trạng thái đơn và khóa ghế được xử lý trong giao dịch CSDL. Chỉ khách sở hữu đơn được xem biên nhận.

## Tài liệu khác

- `Project_rules.md`: quy tắc mã nguồn và bảo mật.
- `UPGRADE.md`: migration, cấu hình Tomcat và lưu ý nâng cấp.
- `TESTING.md`: các kiểm tra đã ghi nhận và hướng dẫn kiểm thử trên CSDL kiểm thử riêng.
