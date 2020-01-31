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

/**
 * @author laoyingyong
 * @date: 2020-01-31 17:44
 */
@WebServlet("/FindNewestServlet")
public class FindNewestServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String stationName = request.getParameter("stationName");
        WaterQualityService service=new WaterQualityServiceImpl();
        WaterQuality newestRecord = service.findNewestRecord(stationName);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset=utf-8");
        mapper.writeValue(response.getOutputStream(),newestRecord);


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
