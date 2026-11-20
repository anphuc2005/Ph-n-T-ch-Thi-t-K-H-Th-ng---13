package vn.cineman;
import org.junit.jupiter.api.Test;import static org.junit.jupiter.api.Assertions.*;import vn.cineman.service.Vnpay8;import vn.cineman.model.Show8;import java.util.*;import java.time.*;import java.math.*;
class UpgradeTest8 {
 @Test void jdbcDatetimeMapping(){var t=LocalDateTime.of(2026,11,20,18,0);var show=Show8.from(Map.of("id",1L,"room_id",2L,"starts_at",t,"price",BigDecimal.TEN));assertEquals(t,show.startsAt());}
 @Test void canonicalSigning(){var params=new HashMap<String,String>();params.put("vnp_TxnRef","12");params.put("vnp_OrderInfo","Thanh toan ve");params.put("vnp_Amount","9000000");params.put("vnp_SecureHash","ignored");assertEquals("vnp_Amount=9000000&vnp_OrderInfo=Thanh+toan+ve&vnp_TxnRef=12",Vnpay8.canonical(params));String signature=Vnpay8.sign(params,"test-secret");assertEquals(128,signature.length());params.put("vnp_Amount","100");assertNotEquals(signature,Vnpay8.sign(params,"test-secret"));}
 @Test void missingConfigurationFailsClosed(){if(!Vnpay8.ready()){assertFalse(Vnpay8.valid(Map.of()));assertThrows(IllegalArgumentException.class,()->Vnpay8.url(1,BigDecimal.TEN,"127.0.0.1",LocalDateTime.now()));}}
 @Test void rejectInvalidPosters(){
  jakarta.servlet.http.Part fake=(jakarta.servlet.http.Part)java.lang.reflect.Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{jakarta.servlet.http.Part.class},(proxy,method,args)->{if(method.getName().equals("getSize"))return 10L;if(method.getName().equals("getInputStream"))return new java.io.ByteArrayInputStream("not an image".getBytes());return null;});
  assertThrows(IllegalArgumentException.class,()->vn.cineman.util.Posters8.save(fake));
  assertThrows(IllegalArgumentException.class,()->vn.cineman.util.Posters8.save(null));
 }
}
