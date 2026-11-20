package vn.cineman.service;

import vn.cineman.dao.*;
import vn.cineman.model.*;
import java.util.*;
import java.math.*;
import java.time.*;

public class CheckoutService8 {
 public static final BigDecimal VIP_SURCHARGE = new BigDecimal("10000");

 public static boolean isVip(String label) {
  if (label == null || label.isEmpty()) return false;
  char r = Character.toUpperCase(label.charAt(0));
  return r == 'C' || r == 'D' || r == 'E';
 }

 private final CinemaService8 cinema=new CinemaService8();
 private final CheckoutDao8 checkout=new CheckoutDao8();

 private String phone(String raw){
  if(raw==null)throw new IllegalArgumentException("Nhập số điện thoại liên hệ.");
  String value=raw.trim();String digits=value.replaceAll("\\D","");
  if(!value.matches("\\+?[0-9() .-]{8,20}")||digits.length()<8||digits.length()>15)throw new IllegalArgumentException("Số điện thoại cần có từ 8 đến 15 chữ số.");
  return value;
 }

 /** Creates an online order and a five-minute seat hold before the demo payment step. */
 public long begin(User8 user,long show,List<Long> seats,String card,String contactPhone,String key)throws Exception{
  CinemaService8.allow(user,"CUSTOMER");UUID.fromString(key);
  String phone=phone(contactPhone);
  if(seats.isEmpty()||seats.size()>30||new HashSet<>(seats).size()!=seats.size())throw new IllegalArgumentException("Chọn từ 1 đến 30 ghế khác nhau.");
  return cinema.transaction(c->{
   var s=cinema.dao.show(c,show);if(s==null)throw new IllegalArgumentException("Suất không tồn tại.");
   checkout.expire(c,show);var old=cinema.dao.existing(c,key);
   if(old!=null){if(((Number)old.get("actor_id")).longValue()!=user.id())throw new SecurityException();return ((Number)old.get("id")).longValue();}
   if(!Show8.from(s).startsAt().isAfter(LocalDateTime.now(ZoneId.of("Asia/Ho_Chi_Minh")).plusMinutes(5)))throw new IllegalArgumentException("Không thể đặt vé trong vòng 5 phút trước giờ chiếu.");
   if(card!=null&&!card.isBlank()){var m=cinema.dao.member(c,card.trim());if(m==null||((Number)m.get("user_id")).longValue()!=user.id())throw new IllegalArgumentException("Mã thẻ không hợp lệ hoặc không thuộc tài khoản của bạn.");}
   for(long seat:seats)if(!cinema.dao.seatAvailable(c,show,((Number)s.get("room_id")).longValue(),seat))throw new IllegalArgumentException("Ghế đã bán hoặc đang được giữ. Vui lòng chọn lại.");
   var contact=cinema.dao.customerContact(c,user.id());if(contact==null)throw new SecurityException();
   cinema.dao.customerPhone(c,user.id(),phone);
   BigDecimal basePrice=(BigDecimal)s.get("price");
   var allSeats=cinema.dao.seats(c,show);
   var seatMap=new HashMap<Long,Map<String,Object>>();
   for(var sm:allSeats)seatMap.put(((Number)sm.get("id")).longValue(),sm);
   BigDecimal total=BigDecimal.ZERO;
   Map<Long,BigDecimal> seatPrices=new HashMap<>();
   for(long seatId:seats){
     var sm=seatMap.get(seatId);
     String label=sm!=null?(String)sm.get("label"):"";
     BigDecimal seatPrice=isVip(label)?basePrice.add(VIP_SURCHARGE):basePrice;
     seatPrices.put(seatId,seatPrice);
     total=total.add(seatPrice);
   }
   long id=cinema.dao.onlineOrder(c,user.id(),key,total,(String)contact.get("name"),(String)contact.get("email"),phone);
   checkout.pending(c,id,show);
   for(long seatId:seats)checkout.seat(c,id,show,seatId,seatPrices.get(seatId));
   return id;
  });
 }

 /** Completes the explicitly simulated payment atomically with ticket issuance. */
 public void completeDemo(User8 user,long id)throws Exception{
  CinemaService8.allow(user,"CUSTOMER");
  cinema.transaction(c->{
   var first=cinema.dao.receipt(c,id);checkOwner(first,user);
   long show=((Number)first.get("show_id")).longValue();cinema.dao.show(c,show);checkout.expire(c,show);
   var order=checkout.order(c,id);String state=(String)order.get("status");
   if("PAID".equals(state))return null;
   if(!"PENDING".equals(state))return null;
   var seats=checkout.seats(c,id);if(seats.isEmpty())throw new IllegalArgumentException("Đơn hàng không có ghế.");
   for(var seat:seats){long seatId=((Number)seat.get("seat_id")).longValue();if(!checkout.held(c,id,show,seatId)){checkout.state(c,id,"EXPIRED");return null;}}
   for(var seat:seats)cinema.dao.ticket(c,id,show,((Number)seat.get("seat_id")).longValue(),(BigDecimal)seat.get("price"));
   cinema.dao.payment(c,id,"SIMULATED",(BigDecimal)order.get("total"));checkout.state(c,id,"PAID");return null;
  });
 }

 /** Marks the demo transaction failed and releases its holds without issuing tickets. */
 public void failDemo(User8 user,long id)throws Exception{
  CinemaService8.allow(user,"CUSTOMER");
  cinema.transaction(c->{
   var first=cinema.dao.receipt(c,id);checkOwner(first,user);
   long show=((Number)first.get("show_id")).longValue();cinema.dao.show(c,show);checkout.expire(c,show);
   var order=checkout.order(c,id);String state=(String)order.get("status");
   if("PAID".equals(state))throw new IllegalArgumentException("Đơn đã thanh toán thành công và không thể đánh dấu thất bại.");
   if("PENDING".equals(state))checkout.state(c,id,"FAILED");
   return null;
  });
 }

 private void checkOwner(Map<String,Object> order,User8 user){
  if(order==null||order.get("show_id")==null)throw new IllegalArgumentException("Không tìm thấy đơn đặt vé.");
  if(((Number)order.get("actor_id")).longValue()!=user.id())throw new SecurityException();
 }

 public String notify(Map<String,String> p)throws Exception{
  if(!Vnpay8.valid(p))return "97";
  long id;BigDecimal amount;try{id=Long.parseLong(p.get("vnp_TxnRef"));amount=new BigDecimal(p.get("vnp_Amount")).movePointLeft(2);}catch(Exception e){return "01";}
  return cinema.transaction(c->{var first=cinema.dao.receipt(c,id);if(first==null||first.get("show_id")==null)return "01";long show=((Number)first.get("show_id")).longValue();cinema.dao.show(c,show);checkout.expire(c,show);var order=checkout.order(c,id);if(amount.compareTo((BigDecimal)order.get("total"))!=0)return "04";
   if(checkout.event(c,id)||"PAID".equals(order.get("status")))return "02";
   if(!"00".equals(p.get("vnp_ResponseCode"))||!"00".equals(p.get("vnp_TransactionStatus"))){if("PENDING".equals(order.get("status")))checkout.state(c,id,"FAILED");return "00";}
   String ref=p.get("vnp_TransactionNo");if(ref==null||!ref.matches("[0-9]{1,80}"))return "01";
   checkout.paid(c,id,ref,amount);
   if(!"PENDING".equals(order.get("status"))){checkout.state(c,id,"REVIEW");return "00";}
   for(var seat:checkout.seats(c,id))cinema.dao.ticket(c,id,show,((Number)seat.get("seat_id")).longValue(),(BigDecimal)seat.get("price"));checkout.payment(c,id,ref,amount);checkout.state(c,id,"PAID");return "00";
  });
 }
}
