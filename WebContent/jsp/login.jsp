<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String msg = "";
	String url = "jdbc:mysql://172.18.187.10:3306/boke16337107"; //数据库名
	String user = "user";  //数据库用户名
	String pwd = "123";  //数据库用户密码
	String uid = "";
	String pw = "";
	StringBuilder aler = new StringBuilder();
	if(request.getMethod().equalsIgnoreCase("post")){
		uid = request.getParameter("uid");
		pw = request.getParameter("pw");
		if(uid==""||pw==""){
			aler.append("<div style=\"text-align:center;color:red;\"><strong>登录失败</strong><small>用户名或密码缺失</small></div>");
		}
		else{
			try{
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection(url,user, pwd);
				Statement stmt = con.createStatement();
				String sql=String.format("select * from user where uid='%s'",uid);
				ResultSet rs=stmt.executeQuery(sql);
				int flag=0;
				if (rs.next()){
					rs.previous();
					while (rs.next()) {  
						 if (rs.getString("pw").equals(pw)==false){
							 aler.append("<div style=\"text-align:center;color:red;\"><strong>登录失败</strong><small>用户名或密码错误</small></div>");
							 flag=1;
							 break;
						 } 
		            }
					if(flag==0)
					{
						aler.append("<div style=\"text-align:center;color:red;\"><strong>登录成功</strong></div>");
						session.setAttribute("uid",uid);
						aler.append("<div style=\"text-align:center;color:black;\"><strong>将在3秒后自动跳转</strong></div>");
						response.sendRedirect("search.jsp"); 
					}

				}
				else{
					aler.append("<div style=\"text-align:center;color:red;\"><strong>登录失败</strong><small>用户名或密码错误</small></div>");
					flag=1;
					
				}
				stmt.close(); con.close();
			}
			catch (Exception e) {        
				aler.append("<div class=\"alert alert-login-disconnect\"><strong>登录失败</strong><small>连接失败</small></div>");
	        } 
		} 
	}
%>
<!DOCTYPE html>
<html>
    <head>
        <title>SYSU Library - Login</title>
        <meta charset="utf-8">
        <style>
            @import "css/login.css";
        </style>
    </head>
    <body>
        <div class="backimg">
            <div class="head">
                <p><img src="images/favicon.ico" class="favicon"> SYSU Library</p>
            </div>
            <div class="login_wrapper">
                <div class="login-content">
                    <form action="login.jsp?" method="post">
                        <h2>登录</h2>
                        <div><input type="text" id="lo-username" class="form-control" placeholder="Username" name="uid"/></div>
                        <div><input type="password" id="lo-password" class="form-control" placeholder="Password" name="pw"/></div>
                        <div><input type="submit" class="btn btn-style1" id="btn-login" value="登录" onclick="login()" name="submit1"></div>
                        <div><input type="submit" id="forgetpassword" value="忘记密码" onclick="forgetpassword()" name="submit2"></div>
                    </form>
                </div>
                <%= aler%>
                <div class="to-register">
                    <p>新用户→ <a href='register.jsp'><button class="btn btn-style2" id="btn-to-register">注册界面</button></p>
                </div>
            </div>
        </div>

        <script>
            function forgetpassword(){
                str = "请联系管理员：\n邮箱：651505591@qq.com";
                alert(str);
            }
        </script>
    </body>
</html>

