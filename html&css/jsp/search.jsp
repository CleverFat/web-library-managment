<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>

<%
	request.setCharacterEncoding("utf-8");
	String msg ="";
	String connectString = "jdbc:mysql://172.18.187.10:3306/boke16337107"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
        StringBuilder table=new StringBuilder("");
	String search = request.getParameter("search-input"); 
	String toSearch = request.getParameter("search-btn");
	String searchType1 = request.getParameter("search-type1");
	String searchType2 = request.getParameter("search-type2");
	String searchType3 = request.getParameter("search-type3");
	Integer pgno = 0;   //当前页号 
	Integer pgcnt = 4; //每页行数 
	String param = request.getParameter("pgno"); 
	if(param != null && !param.isEmpty()){ 
		pgno = Integer.parseInt(param); 
	} 
	param = request.getParameter("pgcnt"); 
	if(param != null && !param.isEmpty()){ 
		pgcnt = Integer.parseInt(param); 
	} 
	int pgprev = (pgno>0)?pgno-1:0; 
	int pgnext = pgno+1; 
	
	try{
		
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
	  Statement stmt=con.createStatement();
	  
	  if(toSearch!=null){
		if(searchType1!=null){
			String fmt = "select * from bookrack where isbn ='" + search + "'";
			//String sql = String.format(fmt, pgno*pgcnt, pgcnt);
		    ResultSet rs=stmt.executeQuery(fmt);
		    table.delete(0, table.length()); 
		    table.append("<table class='book-list'><thead class='black'><tr><th>isbn</th><th>封面</th><th>书名</th><th>作者</th><th>出版社</th><th>当前库存</th><th>总库存</th></tr></thead>");
			while(rs.next()) {	
				table.append("<tr>");  
				table.append("<td>"+rs.getString("isbn")+"</td>");   
				table.append("<td>"+"<img src='show.jsp?isbn=" + rs.getString("isbn") + "' height='300'>"+"</td>");				
				table.append("<td>"+rs.getString("title")+"</td>");             
				table.append("<td>"+rs.getString("author")+"</td>");   
				table.append("<td>"+rs.getString("publisher")+"</td>");  
				table.append("<td>"+rs.getString("current_num")+"</td>"); 
				table.append("<td>"+rs.getString("total_num")+"</td>"); 
				table.append("</tr>");  				
			}
			table.append("</table>");
			rs.close();
			stmt.close();
			con.close();
		}
		else if(searchType2!=null){
			String fmt = "select * from bookrack where title like '%" + search + "%'";
		    //String sql = String.format(fmt, pgno*pgcnt, pgcnt);
		    ResultSet rs=stmt.executeQuery(fmt);
		    table.delete(0, table.length()); 
		    table.append("<table class='book-list'><thead class='black'><tr><th>isbn</th><th>封面</th><th>书名</th><th>作者</th><th>出版社</th><th>当前库存</th><th>总库存</th></tr></thead>");
			while(rs.next()) {	
				table.append("<tr>");  
				table.append("<td>"+rs.getString("isbn")+"</td>");   
				table.append("<td>"+"<img src='show.jsp?isbn=" + rs.getString("isbn") + "' height='300'>"+"</td>");				
				table.append("<td>"+rs.getString("title")+"</td>");             
				table.append("<td>"+rs.getString("author")+"</td>");   
				table.append("<td>"+rs.getString("publisher")+"</td>");  
				table.append("<td>"+rs.getString("current_num")+"</td>"); 
				table.append("<td>"+rs.getString("total_num")+"</td>");  
				table.append("</tr>");  
			}
			table.append("</table>");
			rs.close();
			stmt.close();
			con.close();
		}
		else if(searchType3!=null){
			String fmt = "select * from bookrack where author like '%" + search + "%'";
		    //String sql = String.format(fmt, pgno*pgcnt, pgcnt);
		    ResultSet rs=stmt.executeQuery(fmt);
		    table.delete(0, table.length()); 
		    table.append("<table class='book-list'><thead class='black'><tr><th>isbn</th><th>封面</th><th>书名</th><th>作者</th><th>出版社</th><th>当前库存</th><th>总库存</th></tr></thead>");
			while(rs.next()) {	
				table.append("<tr>");  
				table.append("<td>"+rs.getString("isbn")+"</td>");   
				table.append("<td>"+"<img src='show.jsp?isbn=" + rs.getString("isbn") + "' height='300'>"+"</td>");				
				table.append("<td>"+rs.getString("title")+"</td>");             
				table.append("<td>"+rs.getString("author")+"</td>");   
				table.append("<td>"+rs.getString("publisher")+"</td>");  
				table.append("<td>"+rs.getString("current_num")+"</td>"); 
				table.append("<td>"+rs.getString("total_num")+"</td>");  
				table.append("</tr>");  
			}
			table.append("</table>");
			rs.close();
			stmt.close();
			con.close();
		}
	  }
	  else{
	  
	  stmt.close();
	  con.close();
	  }
	}
	catch (Exception e){
	  msg = e.getMessage();
	}
%>


<!DOCTYPE html>
<html>
    <head>
        <title>SYSU Library</title>
        <meta charset="utf-8">
        <style>
            @import "css/body.css";
            @import "css/menu.css";
            @import "css/color.css";
            @import "css/header.css";
            @import "css/img.css";
            @import "css/input.css";
            @import "css/book-list.css";
            @import "css/search.css";
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
            <div class="header header-text">书籍检索</div> 
            <br> 
            <div class="bkground1">
                <div class="search-div">
                    <!-- 静态的就好了 -->
                    <!-- 下拉菜单，可以按书名、作者、isbn搜索，应当支持模糊搜索 -->
                    <!-- 搜索框 -->
                    <!-- 搜索按钮 -->
					<form action="search.jsp" method="post" name="f1">
                    <div class="select-div">
                        检索方式：&nbsp;
						
							<input type="radio" name="search-type1" >ISBN&nbsp;
							<input type="radio" name="search-type2" >书名&nbsp;
							<input type="radio" name="search-type3" >作者
						
                    </div>
                    <div id="inputbox">
						
							<input type="text" name="search-input" class="text-input" id="search-input" placeholder="Text in book information here">
							<input type="submit" name="search-btn" class="btn-follow btn-color1" id="search-btn" value="检索">
						
					</div>
					</form>
                </div>
            </div>
            <br>
            <div class="record-list">
				<%=table%>
				<!--
				<div style="float: right">
				
					<a href="search.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>">上一页</a>
					<a href="search.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>">下一页</a>
				</div>
                <table class="book-list">
                    <thead class="black">
                        <td class="col-isbn">书籍ISBN</td>
                        <td class="col-img">封面</td>
                        <td class="col-name">书名</td>
                        <td class="col-curNum">当前库存</td>
                        <td class="col-totalNum">总库存</td>
                    </thead>
                    <tbody>
                        <td class="col-isbn"></td>
                        <td class="col-img"></td>
                        <td class="col-name"></td>
                        <td class="col-curNum"></td>
                        <td class="col-totalNum"></td>
                    </tbody>
                </table> -->
            </div>
        </div>
    </body>

</html>
