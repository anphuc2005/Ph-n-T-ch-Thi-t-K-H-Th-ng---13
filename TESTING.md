> **Cập nhật v2:** Đọc [UPGRADE.md](UPGRADE.md) trước khi chạy. Cần migration V2; luồng online mới dùng VNPAY sandbox, thay mô phỏng nội bộ. Kết quả bên dưới là lịch sử v1.

# Kiểm thử CineMan

## Kết quả đã thực hiện trong workspace

- Biên dịch toàn bộ Java chính và Java kiểm thử bằng `javac --release 17`: **đạt**. Dùng JDK 25 đi kèm IntelliJ và các JAR sẵn có trong Maven cache (Tomcat 10.1.39, JUnit). Đây là kiểm tra biên dịch, không thay thế Maven build đúng phiên bản trong POM.
- Chạy trực tiếp ba phương thức test trong `CoreTest`: **3/3 đạt** (hash có salt/verify mật khẩu, từ chối nâng quyền, validation trước truy cập DB).
- `node --check src/main/webapp/assets/app.js`: **đạt**.
- Build Maven `test package`: **chưa đạt do môi trường**. Cache mặc định ngoài workspace không cho ghi; khi chuyển cache vào `target/maven-cache`, Maven Central không phân giải DNS. Chưa tạo WAR.
- Chưa chạy JSP trên Tomcat, kiểm thử giao diện trình duyệt hoặc kiểm thử tích hợp MySQL: môi trường chưa có các thành phần cần thiết. Không có ảnh chụp demo được xác nhận.

## Checklist nghiệm thu trên môi trường đầy đủ

| Mã | Thao tác | Kết quả mong đợi |
|---|---|---|
| AUTH-01 | Đăng ký email hợp lệ, đăng nhập/đăng xuất | Tạo CUSTOMER; session đổi khi đăng nhập; đăng xuất mất quyền |
| AUTH-02 | Email trùng, email sai, mật khẩu ngắn/sai | Thông báo phù hợp; không tạo tài khoản trùng |
| ACL-01 | Khách POST tạo phim, mở thống kê/cấp thẻ | HTTP 403 |
| ACL-02 | Khách đổi ID hóa đơn thành đơn người khác | HTTP 403, không lộ nội dung |
| SEC-01 | POST thiếu/sai CSRF; nhập HTML vào tên phim | Từ chối POST; HTML hiển thị như văn bản |
| MOV-01 | Thêm/sửa phim hợp lệ; thời lượng 0/601 | Thành công hợp lệ; từ chối ngoài giới hạn |
| ROOM-01 | Tạo phòng 6×8; sửa/xóa phòng chưa có lịch | Đúng 48 ghế, thao tác thành công |
| REF-01 | Xóa phim/phòng đã có lịch, đổi thời lượng phim đã có lịch | Từ chối và giữ nguyên dữ liệu |
| SHOW-01 | Tạo 2 lịch chồng lấn cùng phòng, kể cả đồng thời | Chỉ lịch không xung đột được tạo |
| SHOW-02 | Hai lịch tiếp giáp, cùng giờ khác phòng | Cho phép |
| CARD-01 | Cấp thẻ hai lần cùng khách; mã sai hoặc thẻ khách khác online | Không tạo thẻ thứ hai; từ chối mã sai/không thuộc khách |
| BUY-01 | Online chọn nhiều ghế, xác nhận, thanh toán thành công | Một đơn, đủ vé, tổng đúng, một thanh toán; in được |
| BUY-02 | Thanh toán thất bại | Không có đơn/vé/thanh toán; ghế còn trống |
| BUY-03 | Hai phiên mua cùng ghế đồng thời | Một thành công, một báo chọn lại; chỉ một vé |
| BUY-04 | Gửi lại cùng requestKey sau thành công | Trả hóa đơn cũ, không nhân đôi doanh thu |
| BUY-05 | Gửi ghế phòng khác, suất đã bắt đầu, ghế lặp | Từ chối, không thay đổi dữ liệu |
| CASH-01 | Nhân viên bán vé có/không có mã thành viên | Thu tiền mặt, xuất vé; gán khách chỉ khi có mã hợp lệ |
| DB-01 | Ngắt DB hoặc gây lỗi INSERT payment trong DB test | Báo lỗi thân thiện; transaction không để lại đơn/vé dở dang |
| STAT-01 | So sánh đơn/vé đã mua với ba thống kê theo khoảng ngày | Tổng khớp; không tính thanh toán thất bại; không cộng nhân số ghế |
| UI-01 | Màn hình 375px và desktop, bàn phím, trang in | Điều hướng được, bảng cuộn ngang, in ẩn navigation |

`BookingIntegrationTest` tự động kiểm tra thanh toán thất bại, hai giao dịch tranh một ghế và gửi lại yêu cầu thành công khi đã bật biến môi trường. Những dòng còn lại là checklist thủ công, chưa được đánh dấu đạt.
