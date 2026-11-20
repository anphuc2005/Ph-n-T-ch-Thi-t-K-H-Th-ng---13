package vn.cineman.controller;
import jakarta.servlet.annotation.*;import jakarta.servlet.http.*;import java.io.*;import java.nio.file.*;import vn.cineman.dao.*;import vn.cineman.util.Posters8;
@WebServlet("/media/posters/*") public class PosterServlet8 extends HttpServlet {
 protected void doGet(HttpServletRequest r,HttpServletResponse s)throws IOException {try(var c=Db8.open()){var m=new CatalogDao8().movie(c,Long.parseLong(r.getPathInfo().substring(1)));if(m==null||m.get("poster_key")==null){s.sendRedirect(r.getContextPath()+"/assets/poster-placeholder.svg");return;}Path p=Posters8.root().resolve((String)m.get("poster_key")).normalize();if(!p.startsWith(Posters8.root())||!Files.isRegularFile(p)){s.sendRedirect(r.getContextPath()+"/assets/poster-placeholder.svg");return;}s.setContentType((String)m.get("poster_mime"));Files.copy(p,s.getOutputStream());}catch(Exception e){s.sendError(404);}}
}
