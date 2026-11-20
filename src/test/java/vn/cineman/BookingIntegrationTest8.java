package vn.cineman;
import org.junit.jupiter.api.*;import org.junit.jupiter.api.condition.EnabledIfEnvironmentVariable;import static org.junit.jupiter.api.Assertions.*;import vn.cineman.dao.*;import vn.cineman.service.*;import vn.cineman.model.*;import java.util.*;import java.util.concurrent.*;
@EnabledIfEnvironmentVariable(named="CINEMAN_INTEGRATION",matches="true")
class BookingIntegrationTest8 {
 @BeforeAll static void configure(){System.setProperty("java.naming.factory.initial",TestContextFactory.class.getName());}
 @AfterAll static void clear(){System.clearProperty("java.naming.factory.initial");}
 public static class TestContextFactory implements javax.naming.spi.InitialContextFactory {
  public javax.naming.Context getInitialContext(java.util.Hashtable<?,?> env){
   javax.sql.DataSource ds=(javax.sql.DataSource)java.lang.reflect.Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{javax.sql.DataSource.class},(proxy,method,args)->{if(method.getName().equals("getConnection"))return java.sql.DriverManager.getConnection(System.getenv("CINEMAN_DB_URL"),System.getenv("CINEMAN_DB_USER"),System.getenv("CINEMAN_DB_PASSWORD"));throw new UnsupportedOperationException();});
   return (javax.naming.Context)java.lang.reflect.Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{javax.naming.Context.class},(proxy,method,args)->{if(method.getName().equals("lookup"))return ds;throw new UnsupportedOperationException();});
  }
 }

 @Test void concurrentSeatAndRetry()throws Exception{var svc=new CinemaService8();var user=svc.login("customer@cineman.local","Demo@12345");long show,seat;try(var c=Db8.open()){var row=svc.dao.shows(c).get(0);show=((Number)row.get("id")).longValue();seat=((Number)svc.dao.seats(c,show).stream().filter(x->((Number)x.get("sold")).intValue()==0).findFirst().orElseThrow().get("id")).longValue();}
 String key=UUID.randomUUID().toString();assertThrows(IllegalArgumentException.class,()->svc.buy(user,show,List.of(seat),"",key,false));
 var pool=Executors.newFixedThreadPool(2);var latch=new CountDownLatch(1);try{Callable<Long> call=()->{latch.await();try{return svc.buy(user,show,List.of(seat),"",UUID.randomUUID().toString(),true);}catch(IllegalArgumentException e){return -1L;}};var a=pool.submit(call);var b=pool.submit(call);latch.countDown();long x=a.get(),y=b.get();assertTrue((x>0)^(y>0));
 try(var c=Db8.open()){var order=svc.dao.receipt(c,x>0?x:y);String retryKey=(String)order.get("request_key");assertEquals(x>0?x:y,svc.buy(user,show,List.of(seat),"",retryKey,true));}
}finally{pool.shutdownNow();}
 }
}
