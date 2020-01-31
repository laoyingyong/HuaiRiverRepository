package web.servlet.waterQuality;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Statistics;
import service.WaterQualityService;
import service.impl.WaterQualityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author laoyingyong
 * @date: 2020-01-30 13:03
 */
@WebServlet("/StatisticsWaterQualityServlet")
public class StatisticsWaterQualityServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String stationName = request.getParameter("stationName");
        WaterQualityService service=new WaterQualityServiceImpl();
        Statistics count = service.count(stationName);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),count);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
