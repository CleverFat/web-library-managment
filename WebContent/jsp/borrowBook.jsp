<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%@ page import="java.sql.*,java.util.regex.Pattern,java.util.regex.Matcher,java.io.*,java.nio.*"%>
<%@ page import="java.util.Date,java.text.SimpleDateFormat"%>
<%
String msg="";
	 {
	    request.setCharacterEncoding("utf-8");
	    String connectString = "jdbc:mysql://172.18.187.10:3306/boke16337107"
	                    + "?autoReconnect=true&useUnicode=true"
	                    + "&characterEncoding=UTF-8";
	    Class.forName("com.mysql.jdbc.Driver");
	    Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
	    String username = "";
	    String uid;
	    uid=(String)session.getAttribute("uid");
	    String isbn = request.getParameter("isbn");
	    String sqlpre=String.format("select * from books where isbn="+isbn);
	    System.out.println("select * from books where isbn="+isbn);
	    Statement stmt0=con.createStatement();
	    ResultSet rs0=stmt0.executeQuery(sqlpre);
	    int bid=0;
	    System.out.println(bid);
	    while(rs0.next())
	    {
	    	bid=rs0.getInt("bid");
	    	String sbn=rs0.getString("isbn");
	    	System.out.println(bid+","+sbn);
	    	String state=rs0.getString("state");
	    	if (state!="out"&&state!="no_loan")
	    	{
	    		String msg1=String.format("update books set state='out' where bid=%d ",bid);
	    		stmt0.execute(msg1);
	    		break;
	    	}
	    }
	    
        username = (String)session.getAttribute("uid");
        Statement stmt=con.createStatement();
        Statement stmt1=con.createStatement();
        Statement stmt2=con.createStatement();
        String sql = String.format("update books, bookrack set bookrack.current_num=bookrack.current_num-1 where books.isbn=bookrack.isbn and books.bid=%d", bid);
        int cnt = stmt.executeUpdate(sql);
        sql="select count(*) as totalCount from borrow_list";
        ResultSet rs=stmt1.executeQuery(sql);
        rs.next();
        int num=rs.getInt(1);
        Date date = new Date();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dt = format.format(date);
        System.out.println(bid);
        sql=String.format("insert into borrow_list values(%d,%d,'%s','%s','%s',false,false)",num+1,bid,uid,dt,dt);
        cnt = stmt2.executeUpdate(sql);
        if(cnt > 0)
            msg = "借书成功";
        stmt.close();
        stmt1.close();
        con.close();
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
    <%if (session.getAttribute("uid")==null){
    		response.sendRedirect("login.jsp");
    	%>
		  <%}else {%>
		  已登录，用户名：<%= session.getAttribute("uid")%>
		  <%}%>
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