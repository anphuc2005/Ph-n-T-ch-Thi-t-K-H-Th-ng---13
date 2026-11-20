package vn.cineman.dao;
import java.sql.*;import java.util.*;
public class CatalogDao8 {
 public List<Map<String,Object>> genres(Connection c)throws SQLException{return Db8.query(c,"SELECT * FROM genres ORDER BY name");}
 public List<Map<String,Object>> search(Connection c,String q,long genre,int page)throws SQLException{return Db8.query(c,"SELECT m.*,(SELECT GROUP_CONCAT(g.name SEPARATOR ', ') FROM genres g JOIN movie_genres mg ON mg.genre_id=g.id WHERE mg.movie_id=m.id) genre_names FROM movies m WHERE m.title LIKE ? AND (?=0 OR EXISTS(SELECT 1 FROM movie_genres mg WHERE mg.movie_id=m.id AND mg.genre_id=?)) ORDER BY m.id DESC LIMIT 13 OFFSET ?","%"+q+"%",genre,genre,(page-1)*12);}
 public Map<String,Object> movie(Connection c,long id)throws SQLException{return CinemaDao8.first(Db8.query(c,"SELECT * FROM movies WHERE id=?",id));}
 public List<Map<String,Object>> shows(Connection c,long movie)throws SQLException{return Db8.query(c,"SELECT s.*,r.name room FROM shows s JOIN rooms r ON r.id=s.room_id WHERE movie_id=? AND starts_at>NOW() ORDER BY starts_at",movie);}
 public long create(Connection c,String title,int duration,String description,List<Long> genres,String key,String file,String mime,long size,java.time.LocalDate releaseDate,String ageRating,String trailerUrl)throws SQLException{
  var old=CinemaDao8.first(Db8.query(c,"SELECT id FROM movies WHERE create_key=?",key));if(old!=null)return ((Number)old.get("id")).longValue();
  var names=new ArrayList<String>();for(long id:genres){var g=CinemaDao8.first(Db8.query(c,"SELECT name FROM genres WHERE id=?",id));if(g==null)throw new IllegalArgumentException("Thể loại không tồn tại.");names.add((String)g.get("name"));}
  long id=Db8.update(c,"INSERT INTO movies(title,genre,duration,description,create_key,poster_key,poster_mime,poster_size,release_date,age_rating,trailer_url) VALUES(?,?,?,?,?,?,?,?,?,?,?)",title,names.get(0),duration,description,key,file,mime,size,releaseDate,ageRating,trailerUrl);
  for(long g:genres)Db8.update(c,"INSERT INTO movie_genres VALUES(?,?)",id,g);return id;
 }
 public List<Map<String,Object>> movieGenres(Connection c,long id)throws SQLException{return Db8.query(c,"SELECT g.* FROM genres g JOIN movie_genres mg ON mg.genre_id=g.id WHERE mg.movie_id=?",id);}
}
