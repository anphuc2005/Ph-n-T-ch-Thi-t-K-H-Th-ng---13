# CineMan — tập trung thêm phim và đặt vé online

## Luồng ứng dụng hiện tại

Luồng chính: khám phá/lọc phim → chi tiết và chọn ngày/giờ → đăng nhập → chọn ghế → kiểm tra tổng tiền → đơn giữ ghế 5 phút → thanh toán mô phỏng → vé/biên nhận/in. Quản lý có form thêm phim với poster, ngày khởi chiếu, phân loại độ tuổi và trailer tùy chọn. Cấu hình phòng/lịch chiếu nằm trong mục quản trị phụ. Quầy, thẻ thành viên và thống kê không còn là trang ứng dụng; dữ liệu/bảng hiện có được giữ.

Thanh toán trên giao diện là mô phỏng bài tập: nút thành công ghi nhận `SIMULATED`, tạo vé và hóa đơn; nút thất bại đánh dấu đơn thất bại, giải phóng ghế, không tạo vé. Luồng mới không chuyển sang VNPAY. Mã tích hợp cũ được giữ riêng để tránh thay đổi cấu hình/callback của các đơn legacy; không tạo đơn VNPAY mới qua giao diện.

## Migration V4 — thông tin liên hệ customer trên đơn hàng

Form đặt vé hiển thị tên/email của tài khoản và yêu cầu số điện thoại. Số điện thoại được lưu vào `users.phone`; bản chụp `contact_name`, `contact_email`, `contact_phone` trên mỗi đơn online được dùng khi hiển thị thanh toán/biên nhận. Migration điền tên/email cho các đơn cũ có tài khoản liên kết, không xóa đơn hoặc dữ liệu hiện có.

Với CSDL đang ở version 3, dừng Tomcat, backup rồi chạy đúng một lần:

```sh
/usr/local/mysql/bin/mysqldump -u root -p --single-transaction --no-tablespaces cineman > cineman-before-v4.sql
/usr/local/mysql/bin/mysql -u root -p cineman < src/main/resources/db/migrations/V4__customer_order_contact.sql
```

Xác nhận version 4 trong `schema_versions`, `users.phone` và ba cột `orders.contact_*` đã xuất hiện trước khi thay WAR. DDL MySQL auto-commit; nếu migration lỗi giữa chừng, kiểm tra trạng thái từng cột và dữ liệu trước khi xử lý tiếp, không chạy lại mù quáng. CSDL mới khởi tạo từ `schema.sql` đã chứa các cột này nên không cần V4.

## Migration V3 — metadata phim

V3 thêm các cột nullable `release_date`, `age_rating`, `trailer_url` vào `movies`. CSDL mới nhận các cột này từ `schema.sql`; CSDL đã chạy V2 cần backup và chạy V3 đúng một lần.

```sh
/usr/local/mysql/bin/mysqldump -u root -p --single-transaction --no-tablespaces cineman > cineman-before-v3.sql
/usr/local/mysql/bin/mysql -u root -p cineman < src/main/resources/db/migrations/V3__movie_metadata.sql
```

Xác nhận version 3 trong `schema_versions` và ba cột mới trong `DESCRIBE movies` trước khi deploy WAR. DDL MySQL auto-commit; nếu bị lỗi giữa migration, đối chiếu trạng thái từng cột trước khi chạy lại. Không phục hồi backup lên CSDL đang dùng nếu chưa kiểm tra bản phục hồi riêng.

## Thay đổi V2 (lịch sử)

Luồng V2 trước đó dùng VNPAY sandbox. Các phần V2 tiếp tục được giữ tương thích dữ liệu, nhưng hướng dẫn sandbox bên dưới chỉ là ghi chú cho giai đoạn tích hợp sau này.

Đã sửa ép `LocalDateTime` sang `Timestamp` trong mua vé; DAO ánh xạ rõ thời gian và model Show có kiểu. Truy vấn doanh thu nhóm ngày/kênh trong bảng dẫn xuất để tương thích `ONLY_FULL_GROUP_BY`. Thông báo hệ thống có mã hỗ trợ, không gộp mọi lỗi thành lỗi kết nối MySQL.

## Áp dụng migration trước khi thay WAR

Không chạy lại schema/seed trên DB hiện có. Ngừng ứng dụng trong thời gian nâng cấp. Từ thư mục `src`, dùng tài khoản quản trị có quyền ALTER/CREATE (tài khoản ứng dụng cineman chỉ cần quyền DML):

```sh
mkdir -p target/backups
/usr/local/mysql/bin/mysqldump -u root -p --single-transaction --no-tablespaces cineman > target/backups/cineman-before-v2.sql
/usr/local/mysql/bin/mysql -u root -p cineman < src/main/resources/db/migrations/V2__catalog_checkout.sql
```

Chỉ tiếp tục nếu backup hoàn tất và có dữ liệu. Script chạy **một lần**; kiểm tra `SELECT * FROM schema_versions` để xác nhận version 2. MySQL DDL auto-commit; nếu script lỗi giữa chừng, dừng triển khai và đối chiếu schema/backup, không chạy lại mù quáng. Migration không xóa dữ liệu cũ. Với DB hoàn toàn mới: schema → seed → V2. Nếu cần quay lại v1 sau khi đã thay schema, giữ ứng dụng dừng và phục hồi backup vào DB riêng để kiểm tra trước khi đổi kết nối.

Danh mục được tạo từ giá trị thể loại cũ. Không tự tách một chuỗi thể loại thành nhiều tên vì có thể làm sai nghĩa. Quản trị viên có thể thêm danh mục bằng SQL; form thêm phim mới và bộ lọc tự lấy danh mục từ MySQL. Tên thể loại tối đa 80 ký tự.

## Poster

Đặt `CINEMAN_UPLOAD_DIR` trong môi trường Tomcat, thư mục thuộc quyền ghi của người chạy Tomcat và ở ngoài webapps/WAR. Mặc định `${catalina.base}/cineman-uploads`. Sao lưu thư mục này cùng DB.

Upload JPEG/PNG thực, tối đa 5 MB và 6000×6000 pixel. Bản này chưa nhận WebP vì ImageIO chuẩn không có decoder WebP; cần decoder riêng nếu mở rộng. File có tên UUID, không lấy đường dẫn từ tên upload. MySQL lưu khóa/MIME/kích thước; `/media/posters/{movieId}` phục vụ file hoặc placeholder khi chưa có ảnh.

Phim demo hiện có không được gán poster phim thương mại không tương ứng. Dùng ảnh được phép sử dụng cho phim tương ứng khi thêm phim. CGV/Beta chặn truy cập trực tiếp trong phiên làm việc nên chưa nhập bộ poster từ hai website đó. Placeholder là SVG local, không phụ thuộc hotlink. Preview dùng blob URL với CSP tương ứng.

## VNPAY sandbox

Đăng ký merchant sandbox với VNPAY, nhận TmnCode và HashSecret. Xem `config/vnpay.env.example`, điền vào môi trường local của Tomcat, không đưa secret vào Git/chat. Khởi động lại Tomcat sau khi đổi biến môi trường.

- Return URL: `http://localhost:8080/cineman/payments/vnpay/return` (hoặc HTTPS URL triển khai).
- IPN: `https://<public-host>/cineman/payments/vnpay/ipn`. Đăng ký endpoint này với sandbox; localhost không nhận được callback từ máy chủ VNPAY. Có thể dùng tunnel HTTPS phục vụ buổi demo, chỉ công khai ứng dụng cần thiết.
- URL chuyển thanh toán cố định sandbox; không có cấu hình chuyển nhầm production.
- Chữ ký HMAC-SHA512 trên tham số sắp xếp/URL encode; tiền VNĐ nhân 100. Backend tính tiền từ giá DB, không tin tổng tiền từ trình duyệt.
- IPN kiểm tra merchant, chữ ký, đơn, tiền, response code và transaction status; lưu mã giao dịch duy nhất. Callback lặp trả mã đã xử lý, không tạo vé lần hai.
- Return chỉ hiển thị trạng thái và kiểm tra chữ ký. Người dùng tải lại trạng thái khi chờ IPN; phải đăng nhập đúng chủ đơn mới xem được.
- Đơn giữ ghế 15 phút. Ghế hết hạn không còn được xem là bị giữ; lần đặt/notify tiếp theo cùng suất dọn bản ghi hết hạn. Việc hết hạn không cần tab trình duyệt mở. Đơn quá hạn hiển thị hết hạn ngay cả trước khi dọn dữ liệu.
- IPN thành công sau hết hạn/hủy thất bại: ghi nhận `payment_events`, chuyển `REVIEW`, không cấp vé. Quản lý đối soát mã đơn và mã VNPAY thủ công; không tự hoàn tiền hoặc bỏ qua tiền đã nhận.
- Thiếu cấu hình sandbox: giao diện báo chưa sẵn sàng và backend từ chối trước khi tạo đơn/giữ ghế. Không giả lập giao dịch thành công.

Tài liệu: https://sandbox.vnpayment.vn/apis/docs/chuyen-doi-thuat-toan/changeTypeHash.html

## Build và trạng thái kiểm chứng

- Java chính/kiểm thử đã biên dịch bằng JDK đi kèm IntelliJ, target Java 17.
- Chạy trực tiếp 7 phương thức kiểm thử trong CoreTest/UpgradeTest: đạt (3 test lõi, ánh xạ thời gian, canonical/chữ ký thay đổi theo số tiền, thiếu cấu hình sandbox từ chối, từ chối poster giả/thiếu).
- Jasper Tomcat 10.1.57 biên dịch các JSP: 0 lỗi.
- Maven offline package với `-DskipTests`: tạo WAR thành công. Test runner Surefire chưa chạy được vì thiếu dependency `surefire-junit-platform` trong cache và DNS Maven Central bị chặn. Không coi đây là Maven test pass.
- Chưa áp dụng migration hoặc kiểm thử MySQL trực tiếp: kết nối `127.0.0.1:3306` bị môi trường thực thi từ chối (OS error 1). Đây không phải bằng chứng mật khẩu hoặc MySQL của bạn sai.
- Chưa xác nhận UI qua trình duyệt, upload end-to-end hoặc callback VNPAY thật. Chưa có merchant sandbox.
- WAR mới chưa thay vào Tomcat đang dùng vì cần migration DB thành công trước.

## Checklist nghiệm thu trên môi trường của bạn

1. Backup/migration hoàn tất, dữ liệu v1 còn nguyên, version 2 xuất hiện.
2. Đăng nhập ba vai trò; xác nhận mua vé không còn lỗi ép kiểu và truy vấn thống kê cũ không lỗi strict SQL.
3. Thêm phim có hai thể loại, upload JPEG/PNG; phim xuất hiện dưới cả hai bộ lọc, không lặp. Nhập sai, mất trường, file giả ảnh/vượt giới hạn: không tạo phim. Gửi lặp: không tạo phim thứ hai.
4. Deploy lại WAR: poster còn; xóa/mất file: placeholder xuất hiện. Kiểm tra mobile và bàn phím.
5. Chọn phim/ngày: chỉ suất của phim và ngày đó. Đăng nhập khi đặt vé quay lại đúng suất.
6. Hai khách cùng chọn một ghế: chỉ một được giữ; sau 15 phút khách khác được đặt. Không thể dùng thẻ của tài khoản khác.
7. Với sandbox đã cấu hình: thanh toán thành công → IPN → đúng số vé và một hóa đơn. Thất bại/đóng tab/sai chữ ký/sai tiền không phát hành vé.
8. IPN lặp hoặc đến trước/sau return: không nhân đôi. Thành công đến muộn chuyển REVIEW; ghế đã cấp cho người khác không bị lấy lại.
9. In hóa đơn chỉ với PAID; truy cập đơn của khách khác bị 403. Form POST thiếu CSRF bị từ chối.
