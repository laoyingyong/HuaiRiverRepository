package web.servlet.waterQualityStation;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.PageBean;
import domain.WaterQualityStation;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import service.WaterQualityStationService;
import service.impl.WaterQualityStationServiceImpl;
import util.JDBCUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/FindByPageServlet")
public class FindByPageServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        WaterQualityStationService service=new WaterQualityStationServiceImpl();
        int totalCount = service.findTotalCount();//总记录数

        String currentPage = request.getParameter("currentPage");
        String pageSize = request.getParameter("pageSize");
        int intCurrentPage=1;
        int intPageSize=10;
        try {
            intCurrentPage = Integer.parseInt(currentPage);
            intPageSize = Integer.parseInt(pageSize);
        } catch (NumberFormatException e) {
            System.out.println(e);
        }
        if(intCurrentPage==0)
        {
            intCurrentPage=1;
        }
        int totalPage=totalCount%intPageSize==0?totalCount/intPageSize:(totalCount/intPageSize+1);
        if (intCurrentPage>totalPage)
        {
            intCurrentPage=totalPage;
        }
        PageBean<WaterQualityStation> pageBean = service.getPageBean(intCurrentPage, intPageSize);
        System.out.println(pageBean);

        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),pageBean);


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
