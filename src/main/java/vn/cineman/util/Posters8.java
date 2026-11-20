package vn.cineman.util;
import jakarta.servlet.http.Part;import java.nio.file.*;import java.util.*;import javax.imageio.*;import javax.imageio.stream.*;import java.io.*;
public final class Posters8 {
 public record Upload8(String key,String mime,long size){}
 public static Path root(){return Path.of(System.getenv().getOrDefault("CINEMAN_UPLOAD_DIR",System.getProperty("catalina.base",".")+"/cineman-uploads")).toAbsolutePath().normalize();}
 public static Upload8 save(Part part)throws IOException{
  if(part==null||part.getSize()==0)throw new IllegalArgumentException("Vui lòng chọn poster JPEG hoặc PNG.");
  if(part.getSize()>5*1024*1024)throw new IllegalArgumentException("Poster tối đa 5 MB.");
  byte[] bytes;try(var in=part.getInputStream()){bytes=in.readAllBytes();}
  String format;try(ImageInputStream in=ImageIO.createImageInputStream(new ByteArrayInputStream(bytes))){var readers=ImageIO.getImageReaders(in);if(!readers.hasNext())throw new IllegalArgumentException("Ảnh không hợp lệ.");var reader=readers.next();try{reader.setInput(in);format=reader.getFormatName().toLowerCase(Locale.ROOT);if(!Set.of("jpeg","png").contains(format))throw new IllegalArgumentException("Chỉ nhận JPEG/PNG.");if(reader.getWidth(0)>6000||reader.getHeight(0)>6000||reader.getWidth(0)<1||reader.getHeight(0)<1)throw new IllegalArgumentException("Kích thước ảnh tối đa 6000 × 6000.");reader.read(0);}finally{reader.dispose();}}
  Files.createDirectories(root());String key=UUID.randomUUID()+"."+format;Files.write(root().resolve(key),bytes,StandardOpenOption.CREATE_NEW);return new Upload8(key,"image/"+format,bytes.length);
 }
 public static void remove(Upload8 u){if(u!=null)try{Files.deleteIfExists(root().resolve(u.key()));}catch(IOException ignored){}}
}
