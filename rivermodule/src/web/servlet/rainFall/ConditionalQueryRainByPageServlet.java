package web.servlet.rainFall;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.PageBean;
import domain.RainFall;
import service.RainFallService;
import service.impl.RainFallServiceImpl;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/ConditionalQueryRainByPageServlet")
public class ConditionalQueryRainByPageServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        RainFallService service=new RainFallServiceImpl();
        Map<String, String[]> parameterMap = request.getParameterMap();
        int totalCount = service.conditionalFindAllCount(parameterMap); //总的记录数

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
        int totalPage=totalCount%intPageSize==0?totalCount/intPageSize:(totalCount/intPageSize+1);
        if(intCurrentPage<=0)
        {
            intCurrentPage=1;
        }
        if(intCurrentPage>totalPage)
        {
            intCurrentPage=totalPage;

        }

        PageBean<RainFall> bean = service.conditonalQueryByPage(intCurrentPage, intPageSize, parameterMap);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset=utf-8");
        System.out.println(bean);
        mapper.writeValue(response.getOutputStream(),bean);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
