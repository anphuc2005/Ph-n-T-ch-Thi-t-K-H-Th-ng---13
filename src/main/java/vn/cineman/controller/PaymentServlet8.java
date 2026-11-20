package vn.cineman.controller;
import jakarta.servlet.annotation.*;import jakarta.servlet.http.*;import java.io.*;import java.util.*;import vn.cineman.service.*;
@WebServlet({"/payments/vnpay/ipn","/payments/vnpay/return"}) public class PaymentServlet8 extends HttpServlet {
 protected void doGet(HttpServletRequest r,HttpServletResponse s)throws IOException{var p=new HashMap<String,String>();for(var e:r.getParameterMap().entrySet()){if(e.getValue().length!=1){s.sendError(400);return;}p.put(e.getKey(),e.getValue()[0]);}
  if(r.getServletPath().endsWith("/return")){if(!Vnpay8.valid(p)){s.sendError(400,"Chữ ký thanh toán không hợp lệ");return;}try{long id=Long.parseLong(p.get("vnp_TxnRef"));s.sendRedirect(r.getContextPath()+"/app?page=receipt&id="+id);}catch(Exception e){s.sendError(400);}return;}
  String code;try{code=new CheckoutService8().notify(p);}catch(Exception e){getServletContext().log("VNPAY IPN failed",e);code="99";}s.setContentType("application/json");s.getWriter().write("{\"RspCode\":\""+code+"\",\"Message\":\""+(code.equals("00")?"Confirm Success":"Not confirmed")+"\"}");
 }
}
