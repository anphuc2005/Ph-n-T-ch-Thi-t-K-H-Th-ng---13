package vn.cineman.controller;
import jakarta.servlet.*;import jakarta.servlet.annotation.*;import vn.cineman.dao.Db8;
@WebListener public class Lifecycle8 implements ServletContextListener {public void contextDestroyed(ServletContextEvent event){Db8.close();}}
