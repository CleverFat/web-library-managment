<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	String msg = "";
	String url = "jdbc:mysql://172.18.187.10:3306/boke16337107"; //数据库名
	String user = "user";  //数据库用户名
	String pwd = "123";  //数据库用户密码
	String uid = "";
	String pw1 = "";
	String pw2 = "";
	StringBuilder aler = new StringBuilder();
	if(request.getMethod().equalsIgnoreCase("post")){
		uid = request.getParameter("uid");
		pw1 = request.getParameter("pw1");
		pw2 = request.getParameter("pw2");
		if(uid==""||pw1==""||pw2==""){
			aler.append("<div style=\"text-align:center;color:red;\"><strong>注册失败</strong><small>用户名或密码缺失</small></div>");
		}
		else if(pw1.equals(pw2)==false){
			aler.append("<div style=\"text-align:center;color:red;\"><strong>注册失败</strong><small>两次输入的密码不一致</small></div>");
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
					aler.append("<div style=\"text-align:center;color:red;\"><strong>注册失败</strong><small>用户名已存在</small></div>");	
				}
				else{
					sql=String.format("insert into user values('%s','%s')",uid,pw1);
					int cnt = stmt.executeUpdate(sql);
					if(cnt>0){
						aler.append("<div style=\"text-align:center;color:red;\"><strong>注册成功</strong></div>");
					}
					else{
						aler.append("<div style=\"text-align:center;color:red;\"><strong>注册失败</strong><small>连接失败</small></div>");
					}
					flag=1;
				}
				stmt.close(); con.close();
			}
			catch (Exception e) {        
				aler.append("<div class=\"alert alert-login-disconnect\"><strong>注册失败</strong><small>连接失败</small></div>");
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
            <div class="register-wrapper">
                <div class="login-content">
                    <form action="register.jsp?" method="post">
                        <h2>注册新账号</h2>
                        <div><input type="text" id="re-username" class="form-control" placeholder="Username" name="uid"></div>
                        <div><input type="password" id="re-password" class="form-control" placeholder="Password" name="pw1"></div>
                        <div><input type="password" id="re-password-conf" class="form-control" placeholder="Password Confirm" name="pw2"></div>
                        <input type="submit" class="btn btn-style1" id="btn-register" value="注册"  name="submit1">
                    </form>
                </div>
                <%=aler %>
                <div class="to-login">
                    <p>老用户→ <a href='login.jsp'><button class="btn btn-style2" id="btn-to-login">登录界面</button></p>
                </div>
            </div>
        </div>

        <script>
        </script>
    </body>
</html>

