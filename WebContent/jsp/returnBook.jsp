<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%@ page import="java.sql.*,java.util.regex.Pattern,java.util.regex.Matcher,java.io.*,java.nio.*"%>
<%
    request.setCharacterEncoding("utf-8");
    String connectString = "jdbc:mysql://172.18.187.10:3306/boke16337107"
                    + "?autoReconnect=true&useUnicode=true"
                    + "&characterEncoding=UTF-8";
    String username = "";
    String bid = request.getParameter("bid");
    String msg="";
    try {
        username = (String)session.getAttribute("uid");
        Class.forName("com.mysql.jdbc.Driver");
        Connection con=DriverManager.getConnection(connectString, 
                     "user", "123");
        Statement stmt=con.createStatement();
        Statement stmt1=con.createStatement();
        String sql = String.format("update borrow_list set is_return=true where bid=%d and uid=%s", bid, username);
        int cnt = stmt.executeUpdate(sql);
        sql = String.format("update books, bookrack set bookrack.current_num=bookrack.current_num+1 where books.isbn=bookrack.isbn and books.bid=%d", bid);
        cnt = stmt1.executeUpdate(sql);
        if(cnt > 0)
            msg = "还书成功";
        stmt.close();
        stmt1.close();
        con.close();
    }
    catch (Exception e){
        msg = "还书失败，请重新还书。";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>SYSU Library</title>
        <meta charset="utf-8">
        <style>
            @import "css/menu.css";
            @import "css/color.css";
            @import "css/header.css";
            @import "css/img.css";
            @import "css/input.css";
            @import "css/book-list.css";
            @import "css/search.css";
            @import "css/body.css";
        </style>
    </head>
    <body>
        <div class="left-menu">
            <div class="menu-div1">
                SYSU Library
            </div>
            <div>
                <h3 class="menu-h3">功能菜单</h3>
                <div class="menu-div2 all-user">
                    <a class="btn-a btn-a1" href="/">首页</a>
                </div>
                <div class="menu-div2 all-user">
                    个人相关
                    <div class="menu-div3"><a class="btn-a btn-a2" href='/'>历史借阅</a></div>
                    <div class="menu-div3"><a class="btn-a btn-a2" href="/">个人信息</a></div>
                </div>
                <div class="menu-div2 all-user">
                    馆藏相关
                    <div class="menu-div3"><a class="btn-a btn-a2" href="/">书籍检索</a></div>
                    <div class="menu-div3"><a class="btn-a btn-a2" href="/">借还挂失</a></div>
                    <div class="menu-div3"><a class="btn-a btn-a2" href="/">最近新书</a></div>
                </div>
                <div class="menu-div2 normal-user">
                    联系我们
                    <div class="menu-div3"><a class="btn-a btn-a2" href="/">书籍推荐</a></div>
                    <div class="menu-div3"><a class="btn-a btn-a2" href="/">志愿者申请</a></div>
                </div>
                <div class="menu-div2 adminster">
                    管理员功能
                    <div class="menu-div3"><a class="btn-a btn-a2" href='/'>书籍入库</a></div>
                    <div class="menu-div3"><a class="btn-a btn-a2" href='/'>书籍挂失</a></div>
                    <div class="menu-div3"><a class="btn-a btn-a2" href='/'>志愿者管理</a></div>
                </div>
            </div>
        </div>
        <div class="span"></div>
        <div class="right-body">
            <div class="header">
                <div class="header-text"><%=msg%></div>
                </div>
            </div> 
            <br>
        </div> 
    </body>
</html>