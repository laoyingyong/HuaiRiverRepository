package web.servlet.waterQualityStation;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.StationAndQuality;
import service.WaterQualityStationService;
import service.impl.WaterQualityStationServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author laoyingyong
 * @date: 2020-02-03 17:07
 */
@WebServlet("/FindStationAndQualityServlet")
public class FindStationAndQualityServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String lo = request.getParameter("jingdu");
        System.out.println("经度是："+lo);

        String la = request.getParameter("weidu");
        System.out.println("纬度是："+la);
        double longitude=0;
        double latitude=0;
        try {
            longitude=Double.parseDouble(lo);
            latitude=Double.parseDouble(la);
        } catch (NumberFormatException e) {
            System.out.println(e);
        }

        WaterQualityStationService service=new WaterQualityStationServiceImpl();
        StationAndQuality stationAndQuality = service.findStationAndQuality(longitude, latitude);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset=utf-8");
        mapper.writeValue(response.getOutputStream(),stationAndQuality);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
