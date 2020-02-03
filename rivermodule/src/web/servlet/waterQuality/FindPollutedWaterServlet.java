package web.servlet.waterQuality;

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
 * @date: 2020-02-02 14:08
 */
@WebServlet("/FindPollutedWaterServlet")
public class FindPollutedWaterServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        WaterQualityService service=new WaterQualityServiceImpl();
        List<WaterQuality> pollutedWater = service.findPollutedWater();
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset=utf-8");
        mapper.writeValue(response.getOutputStream(),pollutedWater);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
