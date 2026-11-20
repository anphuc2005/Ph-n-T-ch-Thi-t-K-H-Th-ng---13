-- Run once after V2 on an existing CineMan database. MySQL DDL auto-commits.
ALTER TABLE movies
  ADD release_date DATE NULL,
  ADD age_rating ENUM('P','K','T13','T16','T18','C') NULL,
  ADD trailer_url VARCHAR(500) NULL;

INSERT INTO schema_versions(version) VALUES(3);
