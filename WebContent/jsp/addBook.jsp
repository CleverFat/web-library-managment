<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.regex.Pattern,java.util.regex.Matcher,java.io.*,java.nio.*"%>
<%!
boolean isNumeric(String str)
{
	for(int i = 0; i < str.length(); i++){
		System.out.println(str.charAt(i));
		if(!Character.isDigit(str.charAt(i))){
		return false;
		}
	}
	return true;
}
%>
<%
	request.setCharacterEncoding("utf-8");
	String msg = "";
	String url = "jdbc:mysql://172.18.187.10:3306/boke16337107"; //数据库名
	String user = "user";  //数据库用户名
	String pwd = "123";  //数据库用户密码
	String isbn = "";
	String title = "";
	String author = "";
	String publisher = "";
	String pubdate = "";
	String num = "";
	String price = "";
	String source = "";
	String image="";
	StringBuilder aler = new StringBuilder();
	if(request.getMethod().equalsIgnoreCase("post")){
		isbn=request.getParameter("isbn");
		title=request.getParameter("title");
		author=request.getParameter("author");
		publisher=request.getParameter("publisher");
		pubdate=request.getParameter("pubdate");
		num=request.getParameter("num");
		price=request.getParameter("price");
		image=request.getParameter("image");
		source=request.getParameter("book-origin");
		if(isbn==""||num==""){
			out.print("<script>alert('入库信息没有填写完整');  </script>");
		}
		else{
			if(!isNumeric(num)||!isNumeric(price)){
				out.print("<script>alert('入库数量或价格不符合格式');  </script>");
			}
			else{					  	
				int num_i = Integer.parseInt(num);
				int price_i=0;
				if(price.equals("")==false){
					price_i = Integer.parseInt(price);
				}
				try{
					Class.forName("com.mysql.jdbc.Driver");
					Connection con = DriverManager.getConnection(url,user, pwd);
					Statement stmt =con.createStatement(
							ResultSet.TYPE_SCROLL_INSENSITIVE,
							ResultSet.CONCUR_UPDATABLE);
					
					String sql=String.format("select * from bookrack where isbn='%s'",isbn);
					ResultSet rs=stmt.executeQuery(sql);
					int flag=0;
					if(rs.next()){
						if(title!=""||author!=""||publisher!=""||pubdate!=""||price!=""){
							
							
							if (rs.getString("title").equals(title)==false||rs.getString("author").equals(author)==false
									||rs.getString("image").equals(image)==false||rs.getString("publisher").equals(publisher)==false
									||rs.getString("pubdate").equals(pubdate)==false||price.equals(rs.getInt("price")+"")==false){
								out.print("<script>alert('该书籍已存储且入库信息不一致');  </script>");
								flag=1;
							}
							
						}
						
						if(flag==0){
							
							int current_num=rs.getInt("current_num")+num_i;
							int total_num=rs.getInt("total_num")+num_i;
							sql=String.format("update bookrack set current_num=%d, total_num=%d where isbn='%s'",current_num,total_num,isbn);
							int cnt = stmt.executeUpdate(sql);

							String state="no_loan";
							sql=String.format("select count(*) totalCount from books");
							rs=stmt.executeQuery(sql);
							int rowCount = 0; 
							if(rs.next()) { 
							  rowCount=rs.getInt("totalCount"); 
							}
							if(num_i>0){
								for(int i=1;i<=num_i;i++){
									sql=String.format("insert into books values('%d','%s','%s')",i+rowCount,isbn,state);
									cnt = stmt.executeUpdate(sql);
								}
							}
							if (cnt>0){
								out.print("<script>alert('入库成功');  </script>");
							}
						}
					}
					
					else{
						
						int current_num=num_i;
						int total_num=num_i;
						sql=String.format("insert into bookrack(isbn,title,author,publisher,pubdate,current_num,total_num,price) values('%s','%s','%s','%s','%s','%d','%d','%d')",
								isbn,title,author,publisher,pubdate,current_num,total_num,price_i);
						int cnt = stmt.executeUpdate(sql);
						if(image!=""){
							File file = new File(image);
							//打开文件
							FileInputStream fin = new FileInputStream(file);
							//建一个缓冲保存数据
							ByteBuffer nbf = ByteBuffer.allocate((int) file.length());
							byte[] array = new byte[1024];
							int offset = 0, length = 0;
							//读存数据
							while ((length = fin.read(array)) > 0) {
								if (length != 1024)
									nbf.put(array, 0, length);
								else
									nbf.put(array);
								offset += length;
							}
						  	//新建一个数组保存要写的内容
							byte[] content = nbf.array();
							sql=String.format("select * from bookrack where isbn='%s'",isbn);
							rs=stmt.executeQuery(sql);
							if(rs.next()){
								rs.updateBytes("image", content);
								rs.updateRow();
							}
						}//存储图片信息						
						
						String state="no_loan";
						sql=String.format("select count(*) totalCount from books");
						rs=stmt.executeQuery(sql);
						int rowCount = 0; 
						if(rs.next()) { 
						  rowCount=rs.getInt("totalCount"); 
						}
						if(num_i>0){
							for(int i=1;i<=num_i;i++){
								sql=String.format("insert into books values('%d','%s','%s')",i+rowCount,isbn,state);
								cnt = stmt.executeUpdate(sql);
							}
						}
						if (cnt>0){
							out.print("<script>alert('入库成功');  </script>");
						}
					}
					
				}
				catch (Exception e) {
					out.print("<script>alert('无法连接数据库');  </script>");
				}
			}
		}
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
            @import "css/addbook.css";
            @import "css/input.css";
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
                    <a class="btn-a btn-a1" href="/search.jsp">首页</a>
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
            <div class="header header-text">书籍入库</div>
            <br>
            <form action="addBook.jsp?" method="post">
            <div class="add-book">
                <div class="input-area">
                    <table class="input-table">
                        <tr>
                            <td>ISBN:</td><td><input type="text" class="text-input" id="addbok-isbn"" name="isbn" placeholder="必填"></div></td>
                        </tr>
                        <tr>
                            <td>书名：</td><td><input type="text" class="text-input" id="addbok-name" name="title" "></div></td>
                        </tr>
                        <tr>
                            <td>作者：</td><td><input type="text" class="text-input" id="addbok-author" name="author"></div></td>
                        </tr>
                        <tr>
                            <td>出版社：</td><td><input type="text" class="text-input" id="addbok-publisher" name="publisher"></div></td>
                        </tr>
                        <tr>
                            <td>出版日期：</td><td><input type="text" class="text-input" id="addbok-pubdate" name="pubdate"></div></td>
                        </tr>
                        <tr>
                            <td>价格：</td><td><input type="text" class="text-input" id="addbok-price" name="price"></div></td>
                        </tr>
                        <tr>
                            <td>数量：</td><td><input type="text" class="text-input" id="addbok-num" name="num" placeholder="必填"></div></td>
                        </tr>
                        <tr>
                            <td>封面：</td><td><input type="file" class="text-input" id="addbok-image" name="image" ></div></td>
                        </tr>
                        <tr>
                            <td>来源：</td>
                            <td>
                                <input type="radio" name="book-origin">购买
                                <input type="radio" name="book-origin">捐赠
                                <input type="radio" name="book-origin">赔偿
                            </td>
                        </tr>
                    </table>
                    <br>
                    <div class="btn-input-div">
                        <input type="button" class="btn btn-color2" id="clear" value="清空">
                        <input type="submit" class="btn btn-color3" id="add-to-library" value="书籍入库">
                    </div>
                </div>
                <script>
                    document.getElementById("clear").addEventListener("click", function() {                   	
                        var list1 = document.querySelectorAll(".text-input");
                        for(var i=0;i<list1.length;i++){
                            list1[i].value = "";
                        }
                        // 单选选项清零未完成
                    });
                </script>
            </div>
            </form>
        </div>
    </body>
</html>