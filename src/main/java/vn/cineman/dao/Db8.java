package vn.cineman.dao;
import java.sql.*;import java.util.*;
public final class Db8 {
 public static Connection open() throws SQLException {
  try { return ((javax.sql.DataSource)new javax.naming.InitialContext().lookup("java:comp/env/jdbc/CineMan")).getConnection(); }
  catch(javax.naming.NamingException e) { throw new SQLException("Configure Tomcat JNDI jdbc/CineMan",e); }
 }
 public static void close() { /* Pool lifecycle is owned by Tomcat. */ }
 public static List<Map<String,Object>> query(Connection c,String sql,Object... args)throws SQLException {try(PreparedStatement p=c.prepareStatement(sql)){bind(p,args);try(ResultSet rs=p.executeQuery()){List<Map<String,Object>> out=new ArrayList<>();while(rs.next()){Map<String,Object> row=new LinkedHashMap<>();for(int i=1;i<=rs.getMetaData().getColumnCount();i++)row.put(rs.getMetaData().getColumnLabel(i),rs.getMetaData().getColumnType(i)==Types.TIMESTAMP ? rs.getObject(i,java.time.LocalDateTime.class) : rs.getObject(i));out.add(row);}return out;}}}
 public static long update(Connection c,String sql,Object... args)throws SQLException{try(PreparedStatement p=c.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)){bind(p,args);p.executeUpdate();try(ResultSet rs=p.getGeneratedKeys()){return rs.next()?rs.getLong(1):0;}}}
 private static void bind(PreparedStatement p,Object[] a)throws SQLException{for(int i=0;i<a.length;i++)p.setObject(i+1,a[i]);}
}
