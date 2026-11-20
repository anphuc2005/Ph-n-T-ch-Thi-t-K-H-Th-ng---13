<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>403 · Truy Cập Bị Từ Chối · CineMan</title>
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
    <div class="error-icon">🚫</div>
    <div class="eyebrow">LỖI PHÂN QUYỀN 403</div>
    <h1 class="error-title">Truy cập bị từ chối</h1>
    <p>Bạn không có quyền truy cập vào chức năng hoặc tài nguyên này.</p>
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
