# Quy tắc dự án - CineMan JSP/Servlet

## Mục tiêu và stack mặc định

- File này áp dụng cho toàn bộ mã nguồn, cấu hình và script CSDL trong thư mục `src/`.
- Xây dựng ứng dụng web CineMan bằng Java, JSP và Servlet theo mô hình MVC/3 tầng.
- Mặc định dùng Apache Tomcat 10.1, Java 11 trở lên và Jakarta Servlet/JSP (`jakarta.*`). Không trộn `javax.servlet.*` với `jakarta.servlet.*`; nếu yêu cầu môn học bắt buộc stack khác, đổi đồng bộ server, API, thư viện và cấu hình.
- Mặc định dùng MySQL Community Server 8.4 LTS và JDBC Connector/J. MySQL cài và chạy được trên macOS; dùng bộ cài DMG chính thức phù hợp với bộ xử lý ARM hoặc Intel. MySQL Workbench là công cụ quản trị tùy chọn, không phải thành phần bắt buộc của ứng dụng.
- Dùng UTF-8/`utf8mb4` cho dữ liệu và nội dung tiếng Việt. Không đưa thông tin đăng nhập thật vào mã nguồn hoặc Git.

## Kiến trúc và tổ chức mã

- Dùng gói WAR có cấu trúc Maven làm mặc định để build/deploy nhất quán. Cấu trúc dự án nằm bên trong thư mục `src/` của workspace.
- Tách trách nhiệm theo tầng: `controller` cho Servlet/Filter, `service` cho nghiệp vụ, `dao` cho JDBC/CSDL, `model` cho dữ liệu/nghiệp vụ và `util` cho thành phần dùng chung. Có thể điều chỉnh tên gói khi cấu trúc dự án hình thành, nhưng không gộp toàn bộ xử lý vào Servlet hoặc JSP.
- Servlet nhận request, kiểm tra đầu vào, gọi service và chọn view/redirect. JSP chỉ dựng giao diện bằng EL/JSTL; không đặt truy vấn SQL, truy cập JDBC hoặc nghiệp vụ trong JSP.
- Đặt JSP nội bộ dưới `WEB-INF/` để trình duyệt không gọi trực tiếp view. Tài nguyên tĩnh để ở vị trí web public phù hợp.
- Đặt script schema/seed/migration ở tài nguyên dự án có thể theo dõi phiên bản. README của dự án cần chỉ rõ cách cấu hình kết nối, tạo CSDL, chạy ứng dụng và nạp dữ liệu demo.

## Quy tắc nghiệp vụ CineMan

- Phạm vi giao diện chính chỉ gồm quản lý thêm phim và khách hàng mua vé trực tuyến. Phim và lịch chiếu được xem công khai; đăng nhập bắt buộc khi tạo đơn. Quản lý phòng/lịch chiếu nằm trong khu vực phụ dành riêng cho quản lý. Bán tại quầy, cấp thẻ và thống kê không hiển thị trong ứng dụng; không xóa dữ liệu/bảng legacy.
- Kiểm tra quyền cho từng request phía server: quản lý thêm phim/cấu hình phòng/lịch; khách hàng đặt vé/xem đơn của chính mình. Vai trò nhân viên bán hàng không được dùng để đặt vé online hoặc truy cập màn hình khách hàng.
- Thanh toán online hiện là mô phỏng được ghi rõ trên giao diện: hỗ trợ trạng thái thành công/thất bại, không trừ tiền thật, không lưu thông tin thẻ và không gọi cổng VNPAY. Chỉ tích hợp gateway khi có yêu cầu mới.
- Thao tác đặt ghế, tạo vé và ghi nhận thanh toán phải nhất quán. Dùng transaction và ràng buộc dữ liệu để không phát hành hai vé cho cùng ghế trong cùng suất chiếu; giữ ghế tối đa 5 phút, sau đó đơn hết hạn và ghế được giải phóng.
- Thao tác đặt ghế, tạo vé và ghi nhận thanh toán phải nhất quán. Dùng transaction và ràng buộc dữ liệu để không phát hành hai vé cho cùng ghế trong cùng suất chiếu; xử lý rõ trường hợp xung đột hoặc giao dịch thất bại.

## JDBC, bảo mật và xử lý lỗi

- Chỉ DAO chịu trách nhiệm tạo và thực thi câu lệnh SQL. Dùng `PreparedStatement` cho dữ liệu đầu vào; không nối chuỗi người dùng vào SQL.
- Đóng `Connection`, `Statement` và `ResultSet` đúng cách; không để rò rỉ kết nối. Dùng `DataSource`/pool khi cấu hình môi trường hỗ trợ; không tạo kết nối tĩnh dùng chung cho nhiều request.
- Lưu URL, username, password và cấu hình môi trường bên ngoài mã nguồn (ví dụ biến môi trường hoặc cấu hình cục bộ bị loại khỏi Git). Cung cấp tệp cấu hình mẫu không chứa bí mật.
- Mã hóa mật khẩu bằng thuật toán băm chuyên dụng nếu hệ thống quản lý mật khẩu; không lưu mật khẩu nguyên văn. Dùng session hợp lý, kiểm tra quyền ở server, validate đầu vào và encode dữ liệu khi hiển thị để giảm nguy cơ XSS/SQL injection.
- Trả thông báo thân thiện cho người dùng; ghi log kỹ thuật cần thiết nhưng không ghi mật khẩu, token hoặc dữ liệu thanh toán nhạy cảm. Không hiển thị stack trace cho người dùng cuối.

## Tiêu chí hoàn thành chức năng

- Chức năng phải có luồng thành công, kiểm tra đầu vào, thông báo lỗi phù hợp và kiểm tra quyền theo vai trò.
- Kiểm tra thủ công tối thiểu: CRUD phim/phòng chiếu theo quyền quản lý; bán vé tại quầy theo quyền nhân viên; đăng ký/tìm kiếm/mua vé theo quyền khách hàng; mã thành viên hợp lệ/không hợp lệ; đặt ghế cạnh tranh; lỗi DB hoặc thanh toán mô phỏng.
- Sau thay đổi, cập nhật script CSDL, hướng dẫn chạy và ảnh/demo nếu nội dung báo cáo phụ thuộc vào thay đổi đó. Không ghi là đã kiểm thử hoặc hoàn tất nếu chưa thực sự chạy và xác nhận.
