USE cineman;
-- Demo only; password for all three accounts: Demo@12345
INSERT INTO users(name,email,password_hash,role) VALUES
('Quản lý CineMan','manager@cineman.local','210000:Q2luZU1hbkRlbW9TYWx0MjY=:RihdstDFJ1fuZT/5/pvbessckdKZySKUXlUtNMsL8T4=','MANAGER'),
('Nhân viên bán hàng','sales@cineman.local','210000:Q2luZU1hbkRlbW9TYWx0MjY=:RihdstDFJ1fuZT/5/pvbessckdKZySKUXlUtNMsL8T4=','SALES'),
('Khách hàng demo','customer@cineman.local','210000:Q2luZU1hbkRlbW9TYWx0MjY=:RihdstDFJ1fuZT/5/pvbessckdKZySKUXlUtNMsL8T4=','CUSTOMER');
INSERT INTO members(user_id,code) SELECT id,'CM-DEMO' FROM users WHERE email='customer@cineman.local';
INSERT INTO movies(title,genre,duration,description) VALUES
('Chuyến tàu bình minh','Phiêu lưu',115,'Một chuyến tàu xuyên qua những miền đất mới, nơi mỗi điểm dừng mở ra một câu chuyện. Phim minh họa cho bài tập.'),
('Phía sau ánh đèn','Tâm lý',105,'Hành trình tìm lại đam mê của những người trẻ trên sân khấu thành phố. Phim minh họa cho bài tập.'),
('Tín hiệu từ ngày mai','Khoa học viễn tưởng',125,'Một thông điệp bất ngờ thay đổi cuộc sống của nhóm bạn trẻ. Phim minh họa cho bài tập.');
INSERT INTO rooms(name,seat_rows,seat_cols) VALUES('Phòng 01',6,8),('Phòng 02',5,8);
INSERT INTO seats(room_id,label) SELECT r.id,CONCAT(a.letter,b.n) FROM rooms r JOIN (SELECT 'A' letter,1 n UNION ALL SELECT 'B',2 UNION ALL SELECT 'C',3 UNION ALL SELECT 'D',4 UNION ALL SELECT 'E',5 UNION ALL SELECT 'F',6) a ON a.n<=r.seat_rows CROSS JOIN (SELECT 1 n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8) b ORDER BY r.id,a.n,b.n;
INSERT INTO shows(movie_id,room_id,starts_at,ends_at,price) SELECT m.id,r.id,TIMESTAMP(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'18:00:00'),DATE_ADD(TIMESTAMP(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'18:00:00'),INTERVAL m.duration MINUTE),90000 FROM movies m JOIN rooms r ON r.name='Phòng 01' WHERE m.title='Chuyến tàu bình minh';
INSERT INTO shows(movie_id,room_id,starts_at,ends_at,price) SELECT m.id,r.id,TIMESTAMP(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'20:00:00'),DATE_ADD(TIMESTAMP(DATE_ADD(CURDATE(),INTERVAL 1 DAY),'20:00:00'),INTERVAL m.duration MINUTE),110000 FROM movies m JOIN rooms r ON r.name='Phòng 02' WHERE m.title='Tín hiệu từ ngày mai';
