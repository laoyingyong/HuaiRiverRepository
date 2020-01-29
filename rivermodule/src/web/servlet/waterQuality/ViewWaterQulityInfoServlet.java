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
 * @date: 2020-01-29 18:25
 */
@WebServlet("/ViewWaterQulityInfoServlet")
public class ViewWaterQulityInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String stationName = request.getParameter("stationName");
        WaterQualityService service=new WaterQualityServiceImpl();
        List<WaterQuality> list = service.findByName(stationName);

        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),list);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
