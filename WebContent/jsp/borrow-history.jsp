<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%

  request.setCharacterEncoding("utf-8");
  String msg ="";
  String username = "";
  String btype = "";
  int totalb = 0;       //借阅总数
  int nowb = 0;         //当前借阅
  int nearb = 0;        //即将到期
  int totalover = 0;    //逾期总数
  int nowover = 0;      //当前逾期
  int comp = 0;         //书籍赔偿
  StringBuilder table = new StringBuilder("");

  String connectString = "jdbc:mysql://172.18.187.10:3306/boke16337107"
                    + "?autoReconnect=true&useUnicode=true"
                    + "&characterEncoding=UTF-8";
  try {
  	username = (String)session.getAttribute("uid");
    Class.forName("com.mysql.jdbc.Driver");
    Connection con=DriverManager.getConnection(connectString, 
                     "user", "123");
    Statement stmt=con.createStatement();
    Statement stmt1=con.createStatement();
    String sql1 = "select borrow_list.bid as bid, bookrack.image as image, bookrack.title as title, borrow_list.borrow_time as borrow_time, borrow_list.is_return as is_return, borrow_list.is_overtime as is_overtime from borrow_list, books, bookrack where borrow_list.bid=books.bid and books.isbn=BOOKRACK.isbn and borrow_list.uid=\'" + username + "\'";
    ResultSet rs = stmt.executeQuery(sql1);

    while(rs.next()) {
        totalb += 1;
        table.append("<tr>");
        table.append("<td>" + rs.getInt("bid") +"</td>");
        table.append("<td>" + rs.getURL("image") +"</td>");
        table.append("<td>" + rs.getString("title") +"</td>");

        Date btime = rs.getDate("borrow_time");
        table.append("<td>" + btime.toString() +"</td>");

        String sql2 = "select * from compensation where bid=" + rs.getInt("bid") + "and uid=\'" + username + "\'";
        ResultSet rsc = stmt1.executeQuery(sql2);
        boolean isreturn = rs.getBoolean("is_return");
        boolean isovertime = rs.getBoolean("is_overtime");
        int canreturn = 0;
        if(rsc.next()) {
            comp += 1;
            btype = rsc.getString("comtype");
        }
        else if(isreturn == true && isovertime == false) {
            btype = "已归还";
        }
        else if(isreturn == true && isovertime == true) {
            totalover += 1;
            btype = "逾期归还";
        }
        else if(isreturn == false && isovertime == false) {
            nowb += 1;
            btype = "未归还";
            canreturn = 1;
        }
        else if(isreturn == false && isovertime == true) {
            nowb += 1;
            totalover += 1;
            nowover += 1;
            btype = "逾期未还";
            canreturn = 1;
        }
        if(canreturn == 1) {
            table.append(String.format("<td><a href='returnBook.jsp?bid='%d'>%s</a></td>", rs.getInt("bid"), btype));
        }
        else {
            table.append("<td>" + btype +"</td>");
        }
        table.append("</tr>");
        rsc.close();
    }

    rs.close();
    stmt.close();
    stmt1.close();
    con.close();
  }
  catch(Exception e) {
    msg = e.getMessage();
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
                <div class="header-text">个人书籍借阅历史</div>
                <br>
                <div class="header-info">
                    <!-- 缺少数据和后端接口 -->
                    <!-- 后三项如果为0则隐藏 -->
                    <div class="header-info-area blue1">借阅总数&nbsp;<%=totalb%>&nbsp;&nbsp;</div>
                    <div class="header-info-area blue2">当前借阅&nbsp;<%=nowb%>&nbsp;&nbsp;</div>
                    <div class="header-info-area yellow">即将到期&nbsp;<%=nearb%>&nbsp;&nbsp;</div>
                    <div class="header-info-area red alert">逾期总数&nbsp;<%=totalover%>&nbsp;&nbsp;</div>
                    <div class="header-info-area red alert">当前逾期&nbsp;<%=nowover%>&nbsp;&nbsp;</div>
                    <div class="header-info-area red alert">书籍赔偿&nbsp;<%=comp%>&nbsp;&nbsp;</div>
                </div>
            </div> 
            <br>
            <div class="record-list">
                <table class="book-list">
                    <thead class="black">
                        <td class="col-id">书籍ID</td>
                        <td class="col-img">封面</td>
                        <td class="col-name">书名</td>
                        <td class="col-date">借出日期</td>
                        <!-- 最后一列显示书籍的状态，包括已归还、未归还、逾期归还、逾期未还和遗失 -->
                        <td class="col-name">书籍状态</td>
                    </thead>
                </table>
            </div>
        </div> 
    </body>
</html>
