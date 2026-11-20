<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>500 · Sự Cố Hệ Thống · CineMan</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
</head>
<body>
<header>
  <div class="header-inner">
    <a class="brand" href="${pageContext.request.contextPath}/app">
      <span class="brand-icon">🎬</span>
      <div>CINE<span>MAN</span></div>
    </a>
  </div>
</header>
<main>
  <div class="auth auth-center">
    <div class="error-icon">⚠️</div>
    <div class="eyebrow">LỖI MÁY CHỦ 500</div>
    <h1 class="error-title">Hệ thống đang gặp sự cố</h1>
    <p>Yêu cầu chưa thể hoàn tất. Đội ngũ kỹ thuật đã ghi nhận và đang xử lý.</p>
    <a class="button btn-home" href="${pageContext.request.contextPath}/app">← Về trang chủ CineMan</a>
  </div>
</main>
<footer>
  <div class="footer-inner footer-center">
    <div>© 2026 CineMan Cinema · Hệ thống quản lý rạp chiếu phim</div>
  </div>
</footer>
</body>
</html>
