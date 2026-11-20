<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<fmt:setLocale value="vi_VN" scope="session"/>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>CineMan · Rạp Chiếu Phim Đẳng Cấp</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/app.css">
  <script defer src="${pageContext.request.contextPath}/assets/app.js"></script>
</head>
<body>

<header>
  <div class="header-inner">
    <a class="brand" href="${pageContext.request.contextPath}/app">
      <span class="brand-icon">🎬</span>
      <div>
        CINE<span>MAN</span>
        <small>ĐIỆN ẢNH &amp; TRẢI NGHIỆM</small>
      </div>
    </a>
    <nav>
      <a href="?page=movies" class="${empty page || page == 'movies' || page == 'detail' ? 'active' : ''}">Phim đang chiếu</a>
      <c:if test="${sessionScope.user.role == 'CUSTOMER'}">
        <a href="?page=orders" class="${page == 'orders' || page == 'receipt' ? 'active' : ''}">Vé của tôi</a>
      </c:if>
      <c:if test="${sessionScope.user.role == 'MANAGER'}">
        <a href="?page=addMovie" class="${page == 'addMovie' ? 'active' : ''}">+ Thêm phim</a>
        <details class="admin-menu">
          <summary>⚙ Cấu hình rạp ▾</summary>
          <div class="dropdown-panel">
            <a href="?page=schedule">Lập lịch chiếu</a>
            <a href="?page=rooms">Quản lý phòng chiếu</a>
          </div>
        </details>
      </c:if>
    </nav>
    <div class="account">
      <c:choose>
        <c:when test="${not empty sessionScope.user}">
          <div class="account-user">
            <span>👤 <c:out value="${sessionScope.user.name}"/></span>
            <span class="user-role-badge">
              <c:choose>
                <c:when test="${sessionScope.user.role == 'MANAGER'}">Quản lý</c:when>
                <c:otherwise>Thành viên</c:otherwise>
              </c:choose>
            </span>
          </div>
          <form method="post" action="${pageContext.request.contextPath}/app">
            <input type="hidden" name="csrf" value="${sessionScope.csrf}">
            <input type="hidden" name="action" value="logout">
            <button class="quiet">Đăng xuất</button>
          </form>
        </c:when>
        <c:otherwise>
          <a class="btn-auth btn-login" href="?page=login">Đăng nhập</a>
          <a class="btn-auth btn-register" href="?page=register">Đăng ký</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</header>

<main>
  <c:if test="${not empty sessionScope.flash}">
    <div class="notice">
      <span>✓</span>
      <div><c:out value="${sessionScope.flash}"/></div>
    </div>
    <c:remove var="flash" scope="session"/>
  </c:if>
  <c:if test="${not empty sessionScope.error}">
    <div role="alert" class="error">
      <span>✕</span>
      <div><c:out value="${sessionScope.error}"/></div>
    </div>
    <c:remove var="error" scope="session"/>
  </c:if>
  <c:if test="${not empty requestScope.error}">
    <div role="alert" class="error">
      <span>✕</span>
      <div><c:out value="${requestScope.error}"/></div>
    </div>
  </c:if>

  <%-- =========================================================================
       PAGE: LOGIN
       ========================================================================= --%>
  <c:if test="${page == 'login'}">
    <div class="auth">
      <div class="eyebrow">CHÀO MỪNG ĐẾN CINEMAN</div>
      <h1>Một tài khoản.<br>Mọi trải nghiệm.</h1>
      <p>Đăng nhập để đặt vé trực tuyến, chọn vị trí ngồi và quản lý lịch sử giao dịch.</p>
      <form method="post" action="${pageContext.request.contextPath}/app">
        <input type="hidden" name="csrf" value="${sessionScope.csrf}">
        <input type="hidden" name="action" value="login">
        <label>Email
          <input name="email" type="email" value="" maxlength="190" autocomplete="username" placeholder="name@example.com" required>
        </label>
        <label>Mật khẩu
          <input name="password" type="password" value="" maxlength="128" autocomplete="current-password" placeholder="Nhập mật khẩu của bạn" required>
        </label>
        <button>Đăng nhập ngay →</button>
      </form>
      <div class="auth-switch">
        Chưa là thành viên? <a href="?page=register">Đăng ký tài khoản mới</a>
      </div>
    </div>
  </c:if>

  <%-- =========================================================================
       PAGE: REGISTER
       ========================================================================= --%>
  <c:if test="${page == 'register'}">
    <div class="auth">
      <div class="eyebrow">THÀNH VIÊN CINEMAN</div>
      <h1>Bắt đầu hành trình điện ảnh</h1>
      <p>Đăng ký tài khoản thành viên để tận hưởng trọn vẹn tiện ích đặt vé trực tuyến.</p>
      <form method="post" action="${pageContext.request.contextPath}/app">
        <input type="hidden" name="csrf" value="${sessionScope.csrf}">
        <input type="hidden" name="action" value="register">
        <label>Họ và tên
          <input name="name" type="text" value="" maxlength="100" placeholder="Nguyễn Văn A" required>
        </label>
        <label>Email
          <input name="email" type="email" value="" maxlength="190" placeholder="name@example.com" required>
        </label>
        <label>Mật khẩu (8–128 ký tự)
          <input name="password" type="password" value="" minlength="8" maxlength="128" placeholder="Tối thiểu 8 ký tự" required>
        </label>
        <button>Tạo tài khoản thành viên →</button>
      </form>
      <div class="auth-switch">
        Đã có tài khoản? <a href="?page=login">Đăng nhập</a>
      </div>
    </div>
  </c:if>

  <%-- =========================================================================
       PAGE: MOVIES (CATALOG)
       ========================================================================= --%>
  <c:if test="${page == 'movies'}">
    <section class="hero">
      <div class="eyebrow">CINEMAN CINEMA · ĐỈNH CAO TRẢI NGHIỆM ĐIỆN ẢNH</div>
      <h1>Chọn phim hay.<br>Đặt ngay ghế đẹp.</h1>
      <p>Cập nhật lịch chiếu mới nhất, chọn vị trí ngồi yêu thích và nhận vé điện tử nhanh chóng.</p>
      <div class="hero-features">
        <span class="feature-pill">🎬 Màn chiếu Laser 4K</span>
        <span class="feature-pill">🔊 Âm thanh Dolby Atmos</span>
        <span class="feature-pill">🛋️ Ghế da cao cấp êm ái</span>
        <span class="feature-pill">⚡ Giữ ghế online 5 phút</span>
      </div>
    </section>

    <%-- Quick Booking Bar (CGV & Beta style) --%>
    <c:if test="${not empty movies}">
      <div class="quick-booking-bar">
        <div class="quick-booking-title">⚡ Đặt vé nhanh theo phim</div>
        <div class="quick-booking-controls">
          <select id="quick-movie-select" aria-label="Chọn phim đặt vé nhanh">
            <option value="">-- Chọn phim đang chiếu --</option>
            <c:forEach items="${movies}" var="qm">
              <option value="${qm.id}"><c:out value="${qm.title}"/></option>
            </c:forEach>
          </select>
          <button type="button" id="quick-book-btn">Xem lịch &amp; Đặt vé →</button>
        </div>
      </div>
    </c:if>

    <%-- Search & Genre Filters --%>
    <div class="filters-wrapper">
      <form class="filters" method="get">
        <input type="hidden" name="page" value="movies">
        <div class="filter-search">
          <input name="q" aria-label="Tên phim" placeholder="🔍 Tìm kiếm theo tên phim..." value="<c:out value='${param.q}'/>">
        </div>
        <div class="filter-genre">
          <select name="genre" aria-label="Thể loại">
            <option value="0">Tất cả thể loại</option>
            <c:forEach items="${genres}" var="g">
              <option value="${g.id}" ${param.genre == g.id ? 'selected' : ''}><c:out value="${g.name}"/></option>
            </c:forEach>
          </select>
        </div>
        <button>Lọc phim</button>
      </form>
    </div>

    <div class="section-header">
      <h2>🎬 Phim đang chiếu</h2>
      <c:if test="${not empty movies}">
        <span class="tag-counter">Hiển thị ${fn:length(movies)} phim</span>
      </c:if>
    </div>

    <div class="grid">
      <c:forEach items="${movies}" var="m">
        <article class="movie">
          <div class="poster-wrapper">
            <a href="?page=detail&amp;id=${m.id}">
              <img class="poster-photo" src="${pageContext.request.contextPath}/media/posters/${m.id}" alt="Poster phim <c:out value='${m.title}'/>" loading="lazy">
            </a>
            <c:if test="${not empty m.age_rating}">
              <span class="badge-age badge-age-${m.age_rating}"><c:out value="${m.age_rating}"/></span>
            </c:if>
            <span class="badge-duration">${m.duration}'</span>
          </div>

          <a class="movie-title-link" href="?page=detail&amp;id=${m.id}">
            <h2><c:out value="${m.title}"/></h2>
          </a>
          <div class="movie-genre"><c:out value="${m.genre_names}"/></div>

          <div class="movie-meta">
            <c:if test="${not empty m.release_date}">
              <span>📅 Khởi chiếu <fmt:formatDate value="${m.release_date}" pattern="dd/MM/yyyy"/></span>
            </c:if>
          </div>

          <c:if test="${not empty m.poster_source}">
            <small class="poster-credit">Nguồn: <a href="${m.poster_source}" target="_blank" rel="noopener noreferrer"><c:choose><c:when test="${fn:contains(m.poster_source,'cgv.vncdn.vn')}">CGV Vietnam</c:when><c:otherwise>Beta Cinemas</c:otherwise></c:choose></a></small>
          </c:if>

          <a class="button" href="?page=detail&amp;id=${m.id}">Lịch chiếu &amp; đặt vé →</a>
        </article>
      </c:forEach>
    </div>

    <c:if test="${empty movies}">
      <div class="empty">
        <p>Không tìm thấy phim phù hợp với tiêu chí tìm kiếm.</p>
        <a class="button quiet" href="?page=movies">Xem tất cả phim</a>
      </div>
    </c:if>

    <div class="pagination">
      <c:if test="${index > 1}">
        <c:url var="previous" value="/app">
          <c:param name="page" value="movies"/>
          <c:param name="p" value="${index-1}"/>
          <c:param name="q" value="${param.q}"/>
          <c:param name="genre" value="${param.genre}"/>
        </c:url>
        <a class="button quiet" href="${previous}">← Trang trước</a>
      </c:if>
      <span class="page-indicator">Trang ${index}</span>
      <c:if test="${hasNext}">
        <c:url var="following" value="/app">
          <c:param name="page" value="movies"/>
          <c:param name="p" value="${index+1}"/>
          <c:param name="q" value="${param.q}"/>
          <c:param name="genre" value="${param.genre}"/>
        </c:url>
        <a class="button" href="${following}">Trang sau →</a>
      </c:if>
    </div>
  </c:if>

  <%-- =========================================================================
       PAGE: MOVIE DETAIL & SHOWTIMES
       ========================================================================= --%>
  <c:if test="${page == 'detail'}">
    <c:choose>
      <c:when test="${empty movie}">
        <div class="empty">
          <h1>Không tìm thấy thông tin phim</h1>
          <p>Phim bạn tìm kiếm không tồn tại hoặc đã ngừng chiếu.</p>
          <a class="button" href="?page=movies">Quay lại danh sách phim</a>
        </div>
      </c:when>
      <c:otherwise>
        <div class="movie-detail">
          <div class="movie-detail-poster-col">
            <div class="detail-poster-wrap">
              <img class="poster-photo" src="${pageContext.request.contextPath}/media/posters/${movie.id}" alt="Poster phim <c:out value='${movie.title}'/>">
              <c:if test="${not empty movie.age_rating}">
                <span class="badge-age badge-age-${movie.age_rating}"><c:out value="${movie.age_rating}"/></span>
              </c:if>
            </div>
            <c:if test="${not empty movie.trailer_url}">
              <a class="button quiet btn-trailer" href="${movie.trailer_url}" target="_blank" rel="noopener noreferrer">▶ Xem trailer phim ↗</a>
            </c:if>
            <c:if test="${not empty movie.poster_source}">
              <small class="poster-credit">Nguồn poster: <a href="${movie.poster_source}" target="_blank" rel="noopener noreferrer"><c:choose><c:when test="${fn:contains(movie.poster_source,'cgv.vncdn.vn')}">CGV Vietnam</c:when><c:otherwise>Beta Cinemas</c:otherwise></c:choose></a></small>
            </c:if>
          </div>

          <div class="movie-detail-info-col">
            <div class="eyebrow">CINEMAN / THÔNG TIN PHIM</div>
            <h1><c:out value="${movie.title}"/></h1>

            <div class="detail-tags">
              <c:forEach items="${genres}" var="g">
                <span class="chip"><c:out value="${g.name}"/></span>
              </c:forEach>
            </div>

            <div class="detail-meta-grid">
              <div class="detail-meta-item">
                <strong>Thời lượng</strong>
                <span>⏱ ${movie.duration} phút</span>
              </div>
              <div class="detail-meta-item">
                <strong>Phân loại độ tuổi</strong>
                <span>
                  <c:choose>
                    <c:when test="${movie.age_rating == 'P'}">P · Phổ biến mọi lứa tuổi</c:when>
                    <c:when test="${movie.age_rating == 'K'}">K · Dưới 13t có người bảo hộ</c:when>
                    <c:when test="${movie.age_rating == 'T13'}">T13 · Khán giả từ 13 tuổi</c:when>
                    <c:when test="${movie.age_rating == 'T16'}">T16 · Khán giả từ 16 tuổi</c:when>
                    <c:when test="${movie.age_rating == 'T18'}">T18 · Khán giả từ 18 tuổi</c:when>
                    <c:when test="${movie.age_rating == 'C'}">C · Cấm phổ biến</c:when>
                    <c:otherwise>Chưa phân loại</c:otherwise>
                  </c:choose>
                </span>
              </div>
              <div class="detail-meta-item">
                <strong>Ngày khởi chiếu</strong>
                <span>
                  <c:choose>
                    <c:when test="${not empty movie.release_date}">
                      📅 <fmt:formatDate value="${movie.release_date}" pattern="dd/MM/yyyy"/>
                    </c:when>
                    <c:otherwise>Đang cập nhật</c:otherwise>
                  </c:choose>
                </span>
              </div>
            </div>

            <div class="synopsis-box">
              <h3>Nội dung phim</h3>
              <p><c:out value="${movie.description}"/></p>
            </div>

            <%-- Showtimes Section (Modeled after Beta Thanh Xuân) --%>
            <div class="showtimes-box">
              <h2>📅 Lịch chiếu &amp; Suất chiếu</h2>
              <div class="date-selector-bar">
                <label for="show-date">Chọn ngày chiếu:</label>
                <input type="date" id="show-date" aria-label="Ngày chiếu">
              </div>

              <div class="showtimes">
                <c:forEach items="${shows}" var="sh">
                  <a class="button showtime" data-date="${sh.starts_at.toLocalDate()}" href="?page=booking&amp;show=${sh.id}">
                    <span class="showtime-starts"><c:out value="${sh.starts_at}"/></span>
                    <span class="showtime-room">🏛 <c:out value="${sh.room}"/> · 2D Phụ đề</span>
                    <span class="showtime-price"><fmt:formatNumber value="${sh.price}"/> ₫</span>
                    <c:if test="${sessionScope.user.role != 'MANAGER'}">
                      <span class="showtime-action">Chọn ghế ngay →</span>
                    </c:if>
                  </a>
                </c:forEach>
              </div>

              <p id="no-shows" class="empty" ${empty shows ? '' : 'hidden'}>
                Chưa có suất chiếu trong ngày này. Vui lòng chọn ngày khác trong lịch.
              </p>
            </div>
          </div>
        </div>
      </c:otherwise>
    </c:choose>
  </c:if>

  <%-- =========================================================================
       PAGE: BOOKING & SEAT SELECTION (CGV & Beta Cinemas Style)
       ========================================================================= --%>
  <c:if test="${page == 'booking'}">
    <div class="booking-header-card">
      <div>
        <div class="eyebrow">BƯỚC 2: CHỌN GHẾ NGỒI</div>
        <h1><c:out value="${movie.title}"/></h1>
        <div class="booking-show-details">
          <span>🏛 Suất chiếu: <c:out value="${show.starts_at}"/></span>
          <span>📍 Phòng: <c:out value="${show.room}"/></span>
          <span>🎟 Giá vé: Tiêu chuẩn <strong><fmt:formatNumber value="${show.price}"/> ₫</strong> · VIP <strong><fmt:formatNumber value="${show.price + 10000}"/> ₫</strong></span>
        </div>
      </div>
      <div>
        <span class="chip">⏱ Giữ ghế tối đa 5 phút trong bước thanh toán demo</span>
      </div>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/app">
      <input type="hidden" name="csrf" value="${sessionScope.csrf}">
      <input type="hidden" name="action" value="buy">
      <input type="hidden" name="show" value="${show.id}">
      <input type="hidden" name="requestKey" value="${requestKey}">

      <%-- Theater Curved Screen (Classic Cinema) --%>
      <div class="screen-area">
        <div class="screen-curved">
          <span class="screen-title">MÀN HÌNH / SCREEN</span>
        </div>
      </div>

      <%-- Seat Matrix with Row Labels & VIP Distinction --%>
      <div class="seats-wrapper">
        <div class="seats">
          <c:forEach items="${seats}" var="s">
            <c:set var="rowLetter" value="${fn:substring(s.label, 0, 1)}" />
            <c:set var="isVip" value="${rowLetter == 'C' || rowLetter == 'D' || rowLetter == 'E'}" />
            <c:if test="${s.row_start == 1}">
              <span class="row-break" aria-hidden="true"></span>
              <span class="row-badge ${isVip ? 'row-badge-vip' : ''}" aria-hidden="true">${rowLetter}</span>
            </c:if>
            <label class="seat ${s.sold == 1 || s.held == 1 ? 'seat-taken' : (isVip ? 'seat-vip' : 'seat-available')}" title="Ghế ${s.label}${isVip ? ' (Ghế VIP · ' : ' (Tiêu chuẩn · '}<fmt:formatNumber value="${isVip ? show.price + 10000 : show.price}"/> ₫)">
              <input type="checkbox" name="seat" value="${s.id}" data-vip="${isVip ? '1' : '0'}" data-label="${s.label}" ${s.sold == 1 || s.held == 1 ? 'disabled' : ''}>
              <span><c:out value="${s.label}"/></span>
            </label>
          </c:forEach>
        </div>
      </div>

      <%-- Seat Legend --%>
      <div class="seat-legend">
        <div class="legend-item">
          <span class="legend-swatch available"></span>
          <span>Ghế tiêu chuẩn (<fmt:formatNumber value="${show.price}"/> ₫)</span>
        </div>
        <div class="legend-item">
          <span class="legend-swatch vip"></span>
          <span>Ghế VIP (<fmt:formatNumber value="${show.price + 10000}"/> ₫)</span>
        </div>
        <div class="legend-item">
          <span class="legend-swatch selected"></span>
          <span>Ghế đang chọn</span>
        </div>
        <div class="legend-item">
          <span class="legend-swatch taken"></span>
          <span>Ghế đã bán / Đang giữ</span>
        </div>
      </div>

      <%-- Booking Buyer Info & Order Summary Split --%>
      <div class="booking-form-grid">
        <fieldset class="contact-info">
          <legend>📋 Thông tin người mua vé</legend>
          <p>Họ và tên: <strong><c:out value="${buyer.name}"/></strong></p>
          <p>Email nhận vé: <strong><c:out value="${buyer.email}"/></strong></p>
          <label>Số điện thoại liên hệ *
            <input name="contactPhone" type="tel" inputmode="tel" autocomplete="tel" maxlength="20" pattern="\+?[0-9() .-]{8,20}" required value="<c:out value='${buyer.phone}'/>" placeholder="Ví dụ: 0912345678">
          </label>
          <label>Mã thẻ thành viên (nếu có)
            <input name="card" maxlength="40" placeholder="Nhập mã thẻ để tích lũy">
          </label>
        </fieldset>

        <div>
          <button type="button" id="review" class="btn-review">Kiểm tra thông tin &amp; Đặt vé →</button>

          <div id="checkout" hidden>
            <h2>Xác nhận đơn đặt vé</h2>
            <div id="selection" data-price="${show.price}" data-vip-surcharge="10000"></div>
            <p class="checkout-hint">
              ℹ️ Thanh toán mô phỏng dành cho bài tập môn học. Không kết nối ngân hàng hoặc cổng VNPAY. Ghế được giữ trong 5 phút.
            </p>
            <button class="btn-create-order">Tạo đơn và giữ ghế 5 phút →</button>
          </div>
        </div>
      </div>
    </form>
  </c:if>

  <%-- =========================================================================
       PAGE: CHECKOUT & DEMO PAYMENT
       ========================================================================= --%>
  <c:if test="${page == 'checkout'}">
    <c:choose>
      <c:when test="${order.status == 'PENDING'}">
        <div class="receipt">
          <div class="eyebrow">BƯỚC 3: THANH TOÁN MÔ PHỎNG · ĐƠN #CM${order.id}</div>
          <h1>Xác nhận thanh toán vé</h1>

          <div class="hold-timer-card">
            <span class="hold-timer" data-seconds="${secondsLeft}">
              ⏳ Thời gian giữ ghế còn: <strong id="hold-countdown"></strong>
            </span>
            <small class="timer-note">Quá thời gian ghế tự động giải phóng</small>
          </div>

          <table class="checkout-details-table">
            <tr>
              <td>Phim:</td>
              <td><strong><c:out value="${checkoutSeats[0].title}"/></strong></td>
            </tr>
            <tr>
              <td>Suất chiếu:</td>
              <td><c:out value="${checkoutSeats[0].starts_at}"/> · <c:out value="${checkoutSeats[0].room}"/></td>
            </tr>
            <tr>
              <td>Ghế đã chọn:</td>
              <td>
                <c:forEach items="${checkoutSeats}" var="seat">
                  <c:set var="seatRow" value="${fn:substring(seat.label, 0, 1)}" />
                  <c:set var="seatIsVip" value="${seatRow == 'C' || seatRow == 'D' || seatRow == 'E'}" />
                  <span class="chip seat-chip ${seatIsVip ? 'chip-vip' : ''}"><c:out value="${seat.label}"/> <c:choose><c:when test="${seatIsVip}">★ VIP (<fmt:formatNumber value="${seat.price}"/> ₫)</c:when><c:otherwise>(<fmt:formatNumber value="${seat.price}"/> ₫)</c:otherwise></c:choose></span>
                </c:forEach>
              </td>
            </tr>
            <tr>
              <td>Người mua vé:</td>
              <td><c:out value="${order.contact_name}"/> · <c:out value="${order.contact_email}"/> · <c:out value="${order.contact_phone}"/></td>
            </tr>
          </table>

          <div class="checkout-total-row">
            <span>Tổng số tiền cần thanh toán:</span>
            <span><fmt:formatNumber value="${order.total}"/> ₫</span>
          </div>

          <div class="notice notice-demo">
            <span>ℹ️</span>
            <div>Đây là chức năng thanh toán thử nghiệm phục vụ bài tập lớn. Không có tiền thật bị trừ.</div>
          </div>

          <div class="demo-payment-actions">
            <form method="post" action="${pageContext.request.contextPath}/app">
              <input type="hidden" name="csrf" value="${sessionScope.csrf}">
              <input type="hidden" name="action" value="completeDemoPayment">
              <input type="hidden" name="id" value="${order.id}">
              <button id="demo-pay">✓ Mô phỏng thanh toán thành công (Xuất vé)</button>
            </form>
            <form method="post" action="${pageContext.request.contextPath}/app">
              <input type="hidden" name="csrf" value="${sessionScope.csrf}">
              <input type="hidden" name="action" value="failDemoPayment">
              <input type="hidden" name="id" value="${order.id}">
              <button class="quiet" id="demo-fail">✕ Mô phỏng thanh toán thất bại (Hủy giữ ghế)</button>
            </form>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <div class="receipt">
          <c:choose>
            <c:when test="${order.status == 'PAID'}">
              <div class="alert alert-success">
                ✓ Đơn hàng #CM${order.id} đã hoàn tất thanh toán thành công!
              </div>
              <h1>Vé điện tử đã được phát hành</h1>
              <p>Mã vé và mã QR soát vé đã sẵn sàng để check-in tại rạp.</p>
              <div class="checkout-actions-group">
                <a class="button" href="?page=receipt&amp;id=${order.id}">Xem vé điện tử &amp; Mã QR ↗</a>
                <a class="button quiet" href="?page=orders">Danh sách Vé của tôi</a>
              </div>
            </c:when>
            <c:when test="${order.status == 'EXPIRED'}">
              <div class="alert alert-warning">
                ⚠️ Đơn hàng #CM${order.id} đã hết thời hạn giữ ghế (5 phút). Ghế đã tự động được giải phóng để nhường cho khách hàng khác.
              </div>
              <h1>Thời gian giữ ghế đã hết hạn</h1>
              <p>Suất chiếu vẫn đang mở bán. Bạn có thể chọn lại vị trí ghế mong muốn và hoàn tất thanh toán.</p>
              <div class="checkout-actions-group">
                <c:if test="${not empty order.show_id}">
                  <a class="button btn-action-rebook" href="?page=booking&amp;show=${order.show_id}">🔄 Chọn lại ghế và đặt lại suất này →</a>
                </c:if>
                <a class="button quiet" href="?page=orders">Xem danh sách Vé của tôi</a>
                <a class="button quiet" href="?page=movies">Khám phá phim khác</a>
              </div>
            </c:when>
            <c:otherwise>
              <div class="alert alert-danger">
                ✕ Đơn hàng #CM${order.id} không còn trong trạng thái chờ thanh toán (Trạng thái: <c:out value="${order.status}"/>).
              </div>
              <h1>Không thể tiếp tục thanh toán đơn này</h1>
              <p>Ghế đã được giải phóng. Quý khách vui lòng chọn lại suất chiếu để đặt vé mới.</p>
              <div class="checkout-actions-group">
                <c:if test="${not empty order.show_id}">
                  <a class="button btn-action-rebook" href="?page=booking&amp;show=${order.show_id}">🔄 Đặt lại vé suất này →</a>
                </c:if>
                <a class="button quiet" href="?page=orders">Quay lại Vé của tôi</a>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </c:otherwise>
    </c:choose>
  </c:if>

  <%-- =========================================================================
       PAGE: ORDERS HISTORY (CUSTOMER)
       ========================================================================= --%>
  <c:if test="${page == 'orders'}">
    <div class="eyebrow">LỊCH SỬ GIAO DỊCH</div>
    <h1>Vé &amp; Hóa đơn của tôi</h1>
    <p>Quản lý vé xem phim điện tử, theo dõi trạng thái giữ chỗ thời gian thực, tiếp tục thanh toán hoặc đặt lại vé.</p>

    <div class="table table-orders">
      <table>
        <thead>
          <tr>
            <th>Mã đơn</th>
            <th>Phim &amp; Suất chiếu</th>
            <th>Ghế</th>
            <th>Tổng tiền</th>
            <th>Trạng thái giữ vé</th>
            <th class="col-actions">Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${orders}" var="o">
            <tr class="order-row order-${fn:toLowerCase(o.status)}">
              <td>
                <a class="order-id-link" href="?page=receipt&amp;id=${o.id}" title="Xem chi tiết đơn hàng #CM${o.id}">
                  <strong>#CM${o.id}</strong>
                </a>
                <div class="order-date"><c:out value="${o.created_at}"/></div>
                <span class="chip chip-channel"><c:out value="${o.channel}"/></span>
              </td>
              <td>
                <div class="order-movie-title">
                  <c:choose>
                    <c:when test="${not empty o.movie_title}">
                      <c:out value="${o.movie_title}"/>
                    </c:when>
                    <c:otherwise>
                      <em>Suất chiếu CineMan</em>
                    </c:otherwise>
                  </c:choose>
                </div>
                <c:if test="${not empty o.starts_at}">
                  <div class="order-showtime">
                    🕒 <c:out value="${o.starts_at}"/>
                    <c:if test="${not empty o.room_name}"> · <c:out value="${o.room_name}"/></c:if>
                  </div>
                </c:if>
              </td>
              <td>
                <c:choose>
                  <c:when test="${not empty o.seat_labels}">
                    <span class="order-seats-badge"><c:out value="${o.seat_labels}"/></span>
                  </c:when>
                  <c:otherwise>
                    <span class="text-muted">—</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td>
                <strong class="text-gold"><fmt:formatNumber value="${o.total}"/> ₫</strong>
              </td>
              <td>
                <c:choose>
                  <c:when test="${o.status == 'PAID'}">
                    <span class="badge-status badge-paid">✓ Đã thanh toán</span>
                  </c:when>
                  <c:when test="${o.status == 'PENDING' && o.secondsLeft > 0}">
                    <div class="badge-status badge-pending">
                      ⏳ Giữ chỗ: <strong class="order-timer" data-seconds="${o.secondsLeft}"></strong>
                    </div>
                  </c:when>
                  <c:when test="${o.status == 'EXPIRED'}">
                    <span class="badge-status badge-expired">✕ Hết hạn giữ chỗ</span>
                  </c:when>
                  <c:when test="${o.status == 'REVIEW'}">
                    <span class="badge-status badge-review">⚙ Cần đối soát</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge-status badge-failed">✕ Chưa thanh toán</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="order-actions-cell">
                <div class="order-actions-wrap">
                  <c:choose>
                    <c:when test="${o.status == 'PAID'}">
                      <a class="button quiet btn-sm" href="?page=receipt&amp;id=${o.id}">Xem / In vé ↗</a>
                    </c:when>
                    <c:when test="${o.status == 'PENDING' && o.secondsLeft > 0}">
                      <a class="button btn-action-pay btn-sm" href="?page=checkout&amp;id=${o.id}" data-show-id="${o.show_id}">💳 Thanh toán ngay →</a>
                      <a class="button quiet btn-sm" href="?page=receipt&amp;id=${o.id}">Chi tiết</a>
                    </c:when>
                    <c:when test="${o.status == 'EXPIRED' || o.status == 'FAILED'}">
                      <c:choose>
                        <c:when test="${not empty o.show_id}">
                          <a class="button btn-action-rebook btn-sm" href="?page=booking&amp;show=${o.show_id}">🔄 Đặt lại vé →</a>
                        </c:when>
                        <c:when test="${not empty o.movie_id}">
                          <a class="button btn-action-rebook btn-sm" href="?page=detail&amp;id=${o.movie_id}">🔄 Chọn suất khác →</a>
                        </c:when>
                        <c:otherwise>
                          <a class="button quiet btn-sm" href="?page=movies">Đặt vé mới</a>
                        </c:otherwise>
                      </c:choose>
                      <a class="button quiet btn-sm" href="?page=receipt&amp;id=${o.id}">Chi tiết</a>
                    </c:when>
                    <c:otherwise>
                      <a class="button quiet btn-sm" href="?page=receipt&amp;id=${o.id}">Xem chi tiết</a>
                    </c:otherwise>
                  </c:choose>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
    <c:if test="${empty orders}">
      <div class="empty">
        <p>Bạn chưa có giao dịch đặt vé nào.</p>
        <a class="button" href="?page=movies">Khám phá phim đang chiếu</a>
      </div>
    </c:if>
  </c:if>

  <%-- =========================================================================
       PAGE: RECEIPT & ELECTRONIC TICKETS (VOUCHER)
       ========================================================================= --%>
  <c:if test="${page == 'receipt'}">
    <c:choose>
      <c:when test="${order.status == 'PAID'}">
        <div class="receipt">
          <div class="eyebrow">CINEMAN CINEMA · VÉ ĐIỆN TỬ HỢP LỆ</div>
          <h1>Hóa đơn &amp; Vé xem phim #CM${order.id}</h1>
          <p>Ngày mua: <strong><c:out value="${order.created_at}"/></strong> · Kênh: <span class="chip"><c:out value="${order.channel}"/></span></p>

          <fieldset class="contact-info">
            <legend>Thông tin người nhận vé</legend>
            <p>Họ tên: <strong><c:out value="${order.contact_name}"/></strong> · Email: <strong><c:out value="${order.contact_email}"/></strong> · SĐT: <strong><c:out value="${order.contact_phone}"/></strong></p>
          </fieldset>

          <div class="ticket-wrapper">
            <c:forEach items="${tickets}" var="t">
              <c:set var="seatRow" value="${fn:substring(t.label, 0, 1)}" />
              <c:set var="ticketIsVip" value="${seatRow == 'C' || seatRow == 'D' || seatRow == 'E'}" />
              <article class="ticket ${ticketIsVip ? 'ticket-vip' : ''}">
                <div class="ticket-main-stub">
                  <div class="ticket-header">
                    <span class="ticket-id-badge">🎟 VÉ ĐIỆN TỬ #${t.id}</span>
                    <span class="ticket-type-badge ${ticketIsVip ? 'badge-vip' : 'badge-standard'}">
                      ${ticketIsVip ? '★ HẠNG VÉ VIP' : 'HẠNG TIÊU CHUẨN'}
                    </span>
                  </div>
                  <h2><c:out value="${t.title}"/></h2>
                  <div class="ticket-info-grid">
                    <div>🏛 Phòng: <strong><c:out value="${t.room}"/></strong></div>
                    <div>⏱ Suất chiếu: <strong><c:out value="${t.starts_at}"/></strong></div>
                  </div>
                  <div class="ticket-seat-row">
                    <span>Vị trí ngồi:</span>
                    <span class="ticket-seat-highlight ${ticketIsVip ? 'seat-vip-highlight' : ''}">GHẾ <c:out value="${t.label}"/></span>
                  </div>
                  <p class="ticket-price">
                    Giá vé: <fmt:formatNumber value="${t.price}"/> ₫
                  </p>
                </div>

                <div class="ticket-qr-stub">
                  <div class="ticket-qr-box">
                    <div class="ticket-qr-svg" data-code="CM-${order.id}-${t.id}-${t.label}"></div>
                    <div class="ticket-qr-label">QUÉT MÃ VÀO CỔNG</div>
                    <div class="ticket-qr-code-text">#CM${order.id}-${t.id}</div>
                  </div>
                </div>
              </article>
            </c:forEach>
          </div>

          <div class="checkout-total-row">
            <span>Tổng thanh toán đơn hàng:</span>
            <span><fmt:formatNumber value="${order.total}"/> ₫</span>
          </div>

          <button id="print" class="btn-print">🖨 In vé &amp; Hóa đơn</button>
        </div>
      </c:when>
      <c:otherwise>
        <div class="receipt">
          <div class="eyebrow">TRẠNG THÁI ĐƠN HÀNG #CM${order.id}</div>
          <c:choose>
            <c:when test="${order.status == 'PENDING' && secondsLeft > 0}">
              <h1>Đơn hàng đang chờ thanh toán</h1>
              <div class="alert alert-info hold-timer" data-seconds="${secondsLeft}">
                ⏳ Đơn hàng đang giữ ghế trong <strong id="hold-countdown"></strong>. Vui lòng hoàn tất thanh toán trước khi hết hạn!
              </div>
              <c:if test="${not empty pendingSeats}">
                <div class="pending-order-summary">
                  <p>Phim: <strong><c:out value="${order.movie_title}"/></strong>
                    <c:if test="${not empty order.starts_at}"> · Suất: <c:out value="${order.starts_at}"/></c:if>
                    <c:if test="${not empty order.room_name}"> · <c:out value="${order.room_name}"/></c:if>
                  </p>
                  <p>Ghế đang giữ:
                    <c:forEach items="${pendingSeats}" var="ps">
                      <span class="chip"><c:out value="${ps.label}"/></span>
                    </c:forEach>
                  </p>
                  <p>Tổng tiền: <strong class="text-gold"><fmt:formatNumber value="${order.total}"/> ₫</strong></p>
                </div>
              </c:if>
              <div class="receipt-actions-group">
                <a class="button btn-action-pay" href="?page=checkout&amp;id=${order.id}">💳 Tiếp tục thanh toán ngay →</a>
                <a class="button quiet" href="?page=orders">← Danh sách Vé của tôi</a>
              </div>
            </c:when>
            <c:when test="${order.status == 'EXPIRED'}">
              <h1>Đơn đặt vé đã hết hạn giữ chỗ</h1>
              <div class="alert alert-warning">
                ⚠️ Đơn hàng đã quá thời hạn 5 phút. Các vị trí ghế đã được hệ thống tự động giải phóng để nhường cho khách hàng khác.
              </div>
              <c:if test="${not empty order.movie_title}">
                <p>Phim: <strong><c:out value="${order.movie_title}"/></strong>
                  <c:if test="${not empty order.starts_at}"> · Suất chiếu: <c:out value="${order.starts_at}"/></c:if>
                </p>
              </c:if>
              <div class="receipt-actions-group">
                <c:if test="${not empty order.show_id}">
                  <a class="button btn-action-rebook" href="?page=booking&amp;show=${order.show_id}">🔄 Chọn ghế và đặt lại vé ngay →</a>
                </c:if>
                <a class="button quiet" href="?page=orders">← Danh sách Vé của tôi</a>
                <a class="button quiet" href="?page=movies">Khám phá phim khác</a>
              </div>
            </c:when>
            <c:when test="${order.status == 'REVIEW'}">
              <h1>Đơn hàng cần đối soát giao dịch</h1>
              <div class="alert alert-warning">
                ⚙ Đã ghi nhận giao dịch nhưng đơn cần đối soát kỹ thuật. Chưa phát hành vé. Quý khách vui lòng cung cấp mã đơn <strong>#CM${order.id}</strong> cho nhân viên rạp để được hỗ trợ.
              </div>
              <div class="receipt-actions-group">
                <a class="button quiet" href="?page=orders">← Danh sách Vé của tôi</a>
              </div>
            </c:when>
            <c:otherwise>
              <h1>Giao dịch chưa hoàn tất</h1>
              <div class="alert alert-danger">
                ✕ Giao dịch không hoàn tất hoặc đã bị hủy. Ghế đã được tự động giải phóng.
              </div>
              <div class="receipt-actions-group">
                <c:if test="${not empty order.show_id}">
                  <a class="button btn-action-rebook" href="?page=booking&amp;show=${order.show_id}">🔄 Đặt lại vé suất này →</a>
                </c:if>
                <a class="button quiet" href="?page=orders">← Danh sách Vé của tôi</a>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </c:otherwise>
    </c:choose>
  </c:if>

  <%-- =========================================================================
       PAGE: ADMIN - ADD MOVIE
       ========================================================================= --%>
  <c:if test="${page == 'addMovie'}">
    <div class="eyebrow">QUẢN TRỊ VIÊN / QUẢN LÝ PHIM</div>
    <h1>Thêm phim mới vào rạp</h1>
    <p>Nhập thông tin hiển thị cho khách hàng. Lịch chiếu và phòng chiếu được cấu hình riêng trong mục Cấu hình rạp.</p>

    <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/app" class="admin-form">
      <input type="hidden" name="csrf" value="${sessionScope.csrf}">
      <input type="hidden" name="action" value="createMovie">
      <input type="hidden" name="createKey" value="${sessionScope.createKey}">

      <label>Tên phim *
        <input name="title" required maxlength="150" placeholder="Nhập tên phim chính xác" value="<c:out value='${sessionScope.movieDraft.title}'/>">
      </label>

      <div class="grid-2col">
        <label>Thời lượng (phút) *
          <input name="duration" type="number" required min="1" max="600" placeholder="Ví dụ: 120" value="<c:out value='${sessionScope.movieDraft.duration}'/>">
        </label>
        <label>Phân loại độ tuổi
          <select name="ageRating">
            <option value="">Chưa phân loại</option>
            <option value="P" ${sessionScope.movieDraft.ageRating == 'P' ? 'selected' : ''}>P · Phù hợp mọi lứa tuổi</option>
            <option value="K" ${sessionScope.movieDraft.ageRating == 'K' ? 'selected' : ''}>K · Dưới 13t có người bảo hộ</option>
            <option value="T13" ${sessionScope.movieDraft.ageRating == 'T13' ? 'selected' : ''}>T13 · Khán giả từ 13 tuổi</option>
            <option value="T16" ${sessionScope.movieDraft.ageRating == 'T16' ? 'selected' : ''}>T16 · Khán giả từ 16 tuổi</option>
            <option value="T18" ${sessionScope.movieDraft.ageRating == 'T18' ? 'selected' : ''}>T18 · Khán giả từ 18 tuổi</option>
            <option value="C" ${sessionScope.movieDraft.ageRating == 'C' ? 'selected' : ''}>C · Cấm phổ biến</option>
          </select>
        </label>
      </div>

      <fieldset>
        <legend>Thể loại phim *</legend>
        <div class="genre-checkbox-grid">
          <c:forEach items="${genres}" var="g">
            <label class="genre-label">
              <input type="checkbox" name="genres" value="${g.id}" ${sessionScope.movieDraft.genres.contains(g.id.toString()) ? 'checked' : ''}>
              <span><c:out value="${g.name}"/></span>
            </label>
          </c:forEach>
        </div>
      </fieldset>

      <label>Mô tả nội dung phim *
        <textarea name="description" required maxlength="5000" placeholder="Tóm tắt nội dung kịch bản, đạo diễn, diễn viên..."><c:out value="${sessionScope.movieDraft.description}"/></textarea>
      </label>

      <div class="grid-2col">
        <label>Ngày khởi chiếu
          <input name="releaseDate" type="date" value="<c:out value='${sessionScope.movieDraft.releaseDate}'/>">
        </label>
        <label>Trailer URL (HTTPS)
          <input name="trailerUrl" type="url" maxlength="500" placeholder="https://youtube.com/..." value="<c:out value='${sessionScope.movieDraft.trailerUrl}'/>">
        </label>
      </div>

      <label>Poster phim (JPEG/PNG, tối đa 5 MB) *
        <input id="poster-file" name="poster" type="file" accept="image/jpeg,image/png" required>
      </label>
      <img id="poster-preview" class="poster-preview" alt="Xem trước poster" hidden>

      <div class="form-actions">
        <button class="btn-submit">+ Thêm phim vào hệ thống</button>
      </div>
    </form>
  </c:if>

  <%-- =========================================================================
       PAGE: ADMIN - ROOMS
       ========================================================================= --%>
  <c:if test="${page == 'rooms'}">
    <div class="eyebrow">QUẢN TRỊ RẠP</div>
    <h1>Cấu hình phòng chiếu &amp; Sơ đồ ghế</h1>

    <details class="admin-details">
      <summary>+ Thêm phòng chiếu mới</summary>
      <form method="post" action="${pageContext.request.contextPath}/app" class="form-actions">
        <input type="hidden" name="csrf" value="${sessionScope.csrf}">
        <input type="hidden" name="action" value="room">
        <input type="hidden" name="id" value="0">
        <label>Tên phòng chiếu
          <input name="name" type="text" value="" maxlength="80" placeholder="Ví dụ: Phòng chiếu số 1" required>
        </label>
        <div class="grid-2col">
          <label>Số hàng ghế (A - Z, tối đa 26)
            <input name="rows" type="number" value="" min="1" max="26" placeholder="Ví dụ: 8" required>
          </label>
          <label>Số ghế mỗi hàng (tối đa 30)
            <input name="cols" type="number" value="" min="1" max="30" placeholder="Ví dụ: 10" required>
          </label>
        </div>
        <button class="btn-home">Tạo phòng và sinh sơ đồ ghế</button>
      </form>
    </details>

    <div class="grid">
      <c:forEach items="${rooms}" var="r">
        <article class="room-card">
          <h2><c:out value="${r.name}"/></h2>
          <p class="room-capacity">
            🏛 Quy mô: <c:out value="${r.seat_rows}"/> hàng × <c:out value="${r.seat_cols}"/> ghế = ${r.seat_rows * r.seat_cols} ghế
          </p>

          <details>
            <summary>Sửa cấu hình phòng</summary>
            <form method="post" action="${pageContext.request.contextPath}/app">
              <input type="hidden" name="csrf" value="${sessionScope.csrf}">
              <input type="hidden" name="action" value="room">
              <input type="hidden" name="id" value="${r.id}">
              <label>Tên phòng
                <input name="name" type="text" value="<c:out value='${r.name}'/>" maxlength="80" required>
              </label>
              <div class="grid-2col-sm">
                <label>Số hàng
                  <input name="rows" type="number" value="<c:out value='${r.seat_rows}'/>" min="1" max="26" required>
                </label>
                <label>Ghế mỗi hàng
                  <input name="cols" type="number" value="<c:out value='${r.seat_cols}'/>" min="1" max="30" required>
                </label>
              </div>
              <button>Lưu cấu hình</button>
            </form>
          </details>

          <form method="post" action="${pageContext.request.contextPath}/app">
            <input type="hidden" name="csrf" value="${sessionScope.csrf}">
            <input type="hidden" name="action" value="deleteRoom">
            <input type="hidden" name="id" value="${r.id}">
            <button class="quiet danger">Xóa phòng chiếu này</button>
          </form>
        </article>
      </c:forEach>
    </div>
  </c:if>

  <%-- =========================================================================
       PAGE: ADMIN - SCHEDULE
       ========================================================================= --%>
  <c:if test="${page == 'schedule'}">
    <div class="eyebrow">QUẢN TRỊ RẠP</div>
    <h1>Lập lịch chiếu phim</h1>

    <div class="schedule-form-card">
      <h2>+ Tạo suất chiếu mới</h2>
      <form method="post" action="${pageContext.request.contextPath}/app">
        <input type="hidden" name="csrf" value="${sessionScope.csrf}">
        <input type="hidden" name="action" value="schedule">

        <div class="grid-2col">
          <label>Chọn phim *
            <select name="movie" required>
              <c:forEach items="${movies}" var="m">
                <option value="${m.id}"><c:out value="${m.title}"/></option>
              </c:forEach>
            </select>
          </label>
          <label>Phòng chiếu *
            <select name="room" required>
              <c:forEach items="${rooms}" var="r">
                <option value="${r.id}"><c:out value="${r.name}"/></option>
              </c:forEach>
            </select>
          </label>
        </div>

        <div class="grid-2col">
          <label>Thời điểm bắt đầu (Giờ VN) *
            <input name="start" type="datetime-local" value="" required>
          </label>
          <label>Giá vé mỗi ghế (VNĐ) *
            <input name="price" type="number" value="" min="1" max="10000000" placeholder="Ví dụ: 85000" required>
          </label>
        </div>

        <button class="btn-home">Tạo suất chiếu này</button>
      </form>
    </div>

    <div class="section-header">
      <h2>📅 Danh sách lịch chiếu sắp tới</h2>
    </div>

    <div class="table">
      <table>
        <thead>
          <tr>
            <th>Phim</th>
            <th>Phòng chiếu</th>
            <th>Thời gian bắt đầu</th>
            <th>Giá vé</th>
            <th>Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach items="${shows}" var="s">
            <tr>
              <td><strong><c:out value="${s.title}"/></strong></td>
              <td><span class="chip"><c:out value="${s.room}"/></span></td>
              <td><c:out value="${s.starts_at}"/></td>
              <td><strong class="text-gold"><fmt:formatNumber value="${s.price}"/> ₫</strong></td>
              <td>
                <c:if test="${sessionScope.user.role != 'MANAGER'}">
                  <a class="button btn-sm" href="?page=booking&amp;show=${s.id}">Chọn ghế</a>
                </c:if>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </c:if>
</main>

<footer>
  <div class="footer-inner">
    <div class="footer-grid">
      <div class="footer-col">
        <a class="brand footer-brand-logo" href="${pageContext.request.contextPath}/app">
          <span class="brand-icon">🎬</span>
          <div>CINE<span>MAN</span></div>
        </a>
        <p>Hệ thống rạp chiếu phim hiện đại mang đến trải nghiệm nghe nhìn chuẩn quốc tế. Màn chiếu Laser 4K sắc nét và âm thanh đa chiều Dolby Atmos đỉnh cao.</p>
      </div>
      <div class="footer-col">
        <h4>Khám phá</h4>
        <ul>
          <li><a href="?page=movies">Phim đang chiếu</a></li>
          <li><a href="?page=movies">Lịch chiếu toàn hệ thống</a></li>
          <li><a href="?page=login">Thành viên CineMan</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Chính sách</h4>
        <ul>
          <li><a href="#">Quy định phân loại độ tuổi</a></li>
          <li><a href="#">Điều khoản sử dụng</a></li>
          <li><a href="#">Chính sách bảo mật</a></li>
          <li><a href="#">Thanh toán mô phỏng demo</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h4>Liên hệ hỗ trợ</h4>
        <p>📞 Hotline: 1900 6868 (08:00 - 23:00)<br>
        📧 Email: support@cineman.local<br>
        🏢 Trụ sở: Hà Nội, Việt Nam</p>
      </div>
    </div>
    <div class="footer-bottom">
      <div>© 2026 CineMan Cinema · Hệ thống quản lý rạp chiếu phim chuẩn CGV &amp; Beta Cinemas.</div>
      <div>Giờ Việt Nam (UTC+7) · Phiên bản JSP/Servlet Jakarta</div>
    </div>
  </div>
</footer>

</body>
</html>
