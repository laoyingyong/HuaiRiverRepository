package web.servlet.waterQualityStation;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.WaterQuality;
import service.WaterQualityService;
import service.impl.WaterQualityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-03 23:11
 */
@WebServlet("/FindByNameAndTimeServlet")
public class FindByNameAndTimeServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String name = request.getParameter("cezhanName");
        System.out.println(name);
        String star = request.getParameter("startTime");
        String startTime=null;
        if(star!=null)
        {
           startTime=star.replace("T"," ")+":00";
            System.out.println("开始时间"+startTime);
        }
        String end = request.getParameter("endTime");
        String endTime=null;
        if(end!=null)
        {
            endTime=end.replace("T"," ")+":00";
            System.out.println("结束时间"+endTime);
        }
        String water_level = request.getParameter("water_level");
        System.out.println("level:"+water_level);


        WaterQualityService service=new WaterQualityServiceImpl();
        List<WaterQuality> byNameAndTime = service.findByNameAndTime(name, startTime, endTime,water_level);
        System.out.println(byNameAndTime);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset=utf-8");
        mapper.writeValue(response.getOutputStream(),byNameAndTime);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
