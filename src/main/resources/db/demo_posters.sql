-- Optional local demo catalog: requires schema migration V2.
-- Copy src/main/resources/db/posters/* to ${catalina.base}/cineman-uploads first.
-- Override that destination with CINEMAN_UPLOAD_DIR when running Tomcat.
-- Sources: official Beta/CGV listings and image URLs, reviewed 2026-11-15.
-- https://www.betacinemas.vn/phim.htm
-- https://www.cgv.vn/default/movies/now-showing.html/
USE cineman;

INSERT IGNORE INTO genres(name) VALUES
  ('Gia đình'), ('Tình cảm'), ('Hài hước'), ('Hành động'), ('Khoa học viễn tưởng');

INSERT INTO movies(title,genre,duration,description,create_key,poster_key,poster_mime,poster_size,poster_source)
VALUES
  ('Ngày Con Còn Mẹ','Gia đình, Tâm lý',107,
   'Thông tin phim, thể loại và thời lượng tham khảo từ Beta Cinemas.',
   'a71803d1-4444-4c61-a001-000000000001','beta-ngay-con-con-me.jpg','image/jpeg',56009,
   'https://files.betacorp.vn/media%2fimages%2f2026%2f10%2f19%2f111126%2Dngay%2Dcon%2Dcon%2Dme%2D111402%2D191026%2D11.jpg'),
  ('Godzilla Trừ Không','Hành động',135,
   'Thông tin phim, thể loại và thời lượng tham khảo từ Beta Cinemas.',
   'a71803d1-4444-4c61-a002-000000000002','beta-godzilla-tru-khong.png','image/png',162874,
   'https://files.betacorp.vn/media%2fimages%2f2026%2f11%2f02%2f852x1292%2D114213%2D021126%2D52.png'),
  ('Bò Sữa Bay','Tình cảm, Hài hước',108,
   'Thông tin phim, thể loại và thời lượng tham khảo từ Beta Cinemas.',
   'a71803d1-4444-4c61-a003-000000000003','beta-bo-sua-bay.jpg','image/jpeg',50445,
   'https://files.betacorp.vn/media%2fimages%2f2026%2f10%2f02%2fteaser%2Dposter%2Dbsb%2Ddigital%2D2%2D154953%2D021026%2D89.jpg'),
  ('Dune: Hành Tinh Cát – Phần Một (Chiếu Lại)','Hành động, Khoa học viễn tưởng',165,
   'Thông tin phim, thể loại và thời lượng tham khảo từ CGV.',
   'a71803d1-4444-4c61-a004-000000000004','cgv-dune-rerun.jpg','image/jpeg',63225,
   'https://static-cgv.vncdn.vn/media/catalog/product/cache/1/thumbnail/190x260/2e2b8cd282892c71872b9e67d2cb5039/4/7/470x700-dune12-rerun.jpg')
ON DUPLICATE KEY UPDATE
  title=VALUES(title), genre=VALUES(genre), duration=VALUES(duration),
  description=VALUES(description), poster_key=VALUES(poster_key),
  poster_mime=VALUES(poster_mime), poster_size=VALUES(poster_size),
  poster_source=VALUES(poster_source);

INSERT IGNORE INTO movie_genres(movie_id,genre_id)
SELECT m.id,g.id FROM movies m JOIN genres g
  ON (m.title='Ngày Con Còn Mẹ' AND g.name IN ('Gia đình','Tâm lý'))
  OR (m.title='Godzilla Trừ Không' AND g.name='Hành động')
  OR (m.title='Bò Sữa Bay' AND g.name IN ('Tình cảm','Hài hước'))
  OR (m.title='Dune: Hành Tinh Cát – Phần Một (Chiếu Lại)' AND g.name IN ('Hành động','Khoa học viễn tưởng'));
