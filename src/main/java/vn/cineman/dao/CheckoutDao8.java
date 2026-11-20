package vn.cineman.dao;
import java.sql.*;import java.util.*;import java.math.*;
public class CheckoutDao8 {
 public void expireAll(Connection c)throws SQLException{Db8.update(c,"UPDATE orders SET status='EXPIRED' WHERE status='PENDING' AND expires_at<=NOW()");Db8.update(c,"DELETE FROM seat_holds WHERE expires_at<=NOW()");}
 public void expire(Connection c,long show)throws SQLException{Db8.update(c,"UPDATE orders SET status='EXPIRED' WHERE show_id=? AND status='PENDING' AND expires_at<=NOW()",show);Db8.update(c,"DELETE FROM seat_holds WHERE show_id=? AND expires_at<=NOW()",show);}
 public void pending(Connection c,long id,long show)throws SQLException{Db8.update(c,"UPDATE orders SET status='PENDING',show_id=?,expires_at=DATE_ADD(NOW(),INTERVAL 5 MINUTE) WHERE id=?",show,id);}
 public void seat(Connection c,long order,long show,long seat,BigDecimal price)throws SQLException{Db8.update(c,"INSERT INTO order_seats VALUES(?,?,?)",order,seat,price);Db8.update(c,"INSERT INTO seat_holds SELECT ?,?,?,expires_at FROM orders WHERE id=?",show,seat,order,order);}
 public Map<String,Object> order(Connection c,long id)throws SQLException{return CinemaDao8.first(Db8.query(c,"SELECT *,expires_at>NOW() live FROM orders WHERE id=? FOR UPDATE",id));}
 public List<Map<String,Object>> seats(Connection c,long order)throws SQLException{return Db8.query(c,"SELECT * FROM order_seats WHERE order_id=?",order);}
 public List<Map<String,Object>> seatSummary(Connection c,long order)throws SQLException{return Db8.query(c,"SELECT os.seat_id,os.price,se.label,m.title,s.starts_at,r.name room FROM order_seats os JOIN seats se ON se.id=os.seat_id JOIN orders o ON o.id=os.order_id JOIN shows s ON s.id=o.show_id JOIN movies m ON m.id=s.movie_id JOIN rooms r ON r.id=s.room_id WHERE os.order_id=? ORDER BY se.id",order);}
 public boolean held(Connection c,long order,long show,long seat)throws SQLException{return !Db8.query(c,"SELECT seat_id FROM seat_holds WHERE order_id=? AND show_id=? AND seat_id=? AND expires_at>NOW()",order,show,seat).isEmpty();}
 public void state(Connection c,long order,String state)throws SQLException{Db8.update(c,"UPDATE orders SET status=? WHERE id=?",state,order);Db8.update(c,"DELETE FROM seat_holds WHERE order_id=?",order);}
 public boolean event(Connection c,long order)throws SQLException{return !Db8.query(c,"SELECT order_id FROM payment_events WHERE order_id=?",order).isEmpty();}
 public void paid(Connection c,long order,String ref,BigDecimal amount)throws SQLException{Db8.update(c,"INSERT INTO payment_events(order_id,provider_ref,amount) VALUES(?,?,?)",order,ref,amount);}
 public void payment(Connection c,long order,String ref,BigDecimal amount)throws SQLException{Db8.update(c,"INSERT INTO payments(order_id,method,amount,provider_ref) VALUES(?,'VNPAY',?,?)",order,amount,ref);}
}
