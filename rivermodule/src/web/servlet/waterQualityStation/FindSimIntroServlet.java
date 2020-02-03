package web.servlet.waterQualityStation;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.WaterQualityStation;
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
 * @date: 2020-02-03 14:21
 */
@WebServlet("/FindSimIntroServlet")
public class FindSimIntroServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String zuobiao = request.getParameter("zuobiao");
        System.out.println("坐标是："+zuobiao);
        String[] split = zuobiao.split(",");
        String lo=split[0];
        String la=split[1];
        double longitude=0;
        double latitude=0;
        try
        {
            longitude=Double.parseDouble(lo);
            latitude=Double.parseDouble(la);
        } catch (NumberFormatException e)
        {
            System.out.println(e);
        }

        WaterQualityStationService service=new WaterQualityStationServiceImpl();
        WaterQualityStation station = service.findIntro(longitude, latitude);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json/chartset=utf-8");
        mapper.writeValue(response.getOutputStream(),station);


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
