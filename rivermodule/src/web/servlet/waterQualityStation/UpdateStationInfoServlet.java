package web.servlet.waterQualityStation;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import domain.WaterQualityStation;
import service.WaterQualityStationService;
import service.impl.WaterQualityStationServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateStationInfoServlet")
public class UpdateStationInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String id = request.getParameter("id");
        String stationName = request.getParameter("stationName");
        String longitude = request.getParameter("longitude");
        System.out.println(longitude);
        String latitude = request.getParameter("latitude");
        System.out.println(latitude);
        String section = request.getParameter("section");
        String introduction = request.getParameter("introduction");

        WaterQualityStation station=new WaterQualityStation();
        try
        {
            station.setId(Integer.parseInt(id));
            station.setStationName(stationName);
            station.setLongitude(Double.parseDouble(longitude));
            station.setLatitude(Double.parseDouble(latitude));
            station.setSection(section);
            station.setIntroduction(introduction);
        } catch (Exception e)
        {
            System.out.println(e);
        }


        WaterQualityStationService service=new WaterQualityStationServiceImpl();
        boolean flag = service.update(station);
        ResultInfo info=new ResultInfo();
        if(flag)
        {
            info.setMsg("更新成功！");
        }
        else
        {
            info.setMsg("更新失败！");
        }

        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("appilication/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),info);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
