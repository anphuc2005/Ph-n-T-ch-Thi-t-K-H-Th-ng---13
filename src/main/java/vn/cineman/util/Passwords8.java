package vn.cineman.util;
import java.security.*;import java.util.*;import javax.crypto.SecretKeyFactory;import javax.crypto.spec.PBEKeySpec;
public final class Passwords8 {
 public static String hash(String p){byte[] s=new byte[16];new SecureRandom().nextBytes(s);return "210000:"+Base64.getEncoder().encodeToString(s)+":"+Base64.getEncoder().encodeToString(derive(p,s,210000));}
 private static byte[] derive(String p,byte[] s,int n){try{return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(new PBEKeySpec(p.toCharArray(),s,n,256)).getEncoded();}catch(Exception e){throw new IllegalStateException(e);}}
 public static boolean verify(String p,String encoded){try{String[] a=encoded.split(":");return MessageDigest.isEqual(Base64.getDecoder().decode(a[2]),derive(p,Base64.getDecoder().decode(a[1]),Integer.parseInt(a[0])));}catch(RuntimeException e){return false;}}
 public static void main(String[] a){System.out.println(hash(a[0]));}
}
