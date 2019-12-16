package web.servlet.waterLevel;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.PageBean;
import domain.WaterLevel;
import service.WaterLevelService;
import service.impl.WaterLevelServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/FindAllByPageServlet")
public class FindAllByPageServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        WaterLevelService service=new WaterLevelServiceImpl();
        int totalCount = service.findAllCount();


        String currentPage = request.getParameter("currentPage");
        String pageSize = request.getParameter("pageSize");

        int intCurrentPage = 1;
        int intPageSize = 5;
        try {
            intCurrentPage = Integer.parseInt(currentPage);
            intPageSize = Integer.parseInt(pageSize);
        } catch (NumberFormatException e) {
            System.out.println(e);
        }
        if(intCurrentPage==0)
        {
            intCurrentPage = 1;
        }
        int totalPage=totalCount%intPageSize==0?totalCount/intPageSize:(totalCount/intPageSize+1);
        if(intCurrentPage>totalPage)
        {
            intCurrentPage=totalPage;
        }

        PageBean<WaterLevel> pageBean = service.findAllByPage(intCurrentPage, intPageSize);
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
