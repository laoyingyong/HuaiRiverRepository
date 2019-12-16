package web.servlet.rainFall;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.PageBean;
import domain.RainFall;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import util.JDBCUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewRainByPageServlet")
public class ViewRainByPageServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        JdbcTemplate template=new JdbcTemplate(JDBCUtils.getDataSource());
        String sql="select * from rain_fall limit ?,?";//查询部分元组
        String sql2="select * from rain_fall";//查询所有元组
        List<RainFall> countList = template.query(sql2, new BeanPropertyRowMapper<RainFall>(RainFall.class));
        int totalCount=countList.size();//从数据库获取总记录数
        int totalPage;//先声明一下总的页码，总的页码需要根据客户端发送过来的数据进行计算

        String currentPage = request.getParameter("currentPage");
        String pageSize = request.getParameter("pageSize");
        int intCurrentPage = Integer.parseInt(currentPage);//用户发来的当前页码
        if(intCurrentPage==0)//用户点击上一页按钮，currentPage就减1，会出现减到0的情况
        {
            intCurrentPage=1;//如果用户的currentPage=0，直接把页码设为1，把第一页的数据返回给客户端
        }

        int intPageSize = Integer.parseInt(pageSize);//用户发来的页面大小
        totalPage=totalCount%intPageSize==0?totalCount/intPageSize:(totalCount/intPageSize+1);//计算出总的页数
        if(intCurrentPage>totalPage)//用户点击下一页按钮，currentPage就加1，会出现大于总页数的情况
        {
            intCurrentPage=totalPage;//把当前页码设为总页数
        }

        int startIndex=(intCurrentPage-1)*intPageSize;//从索引为几的记录开始查询？

        List<RainFall> list = template.query(sql, new BeanPropertyRowMapper<RainFall>(RainFall.class),startIndex,intPageSize);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");//设置响应数据类型和字符编码
        PageBean<RainFall> pageBean=new PageBean<>();//创建PageBean对象
        //封装PageBean对象
        pageBean.setTotalCount(totalCount);
        pageBean.setTotalPage(totalPage);
        pageBean.setList(list);
        pageBean.setCurrentPage(intCurrentPage);
        pageBean.setRows(intPageSize);
        //将数据写回客户端
        System.out.println(pageBean);
        mapper.writeValue(response.getOutputStream(),pageBean);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
