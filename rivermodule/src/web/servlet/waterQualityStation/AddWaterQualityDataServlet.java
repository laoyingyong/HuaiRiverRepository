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

@WebServlet("/AddWaterQualityDataServlet")
public class AddWaterQualityDataServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String stationName = request.getParameter("stationName");
        String section = request.getParameter("section");
        String introduction = request.getParameter("introduction");
        WaterQualityStation station=new WaterQualityStation();
        //封装对象
        station.setStationName(stationName);
        station.setSection(section);
        station.setIntroduction(introduction);

        WaterQualityStationService service=new WaterQualityStationServiceImpl();
        boolean flag = service.addWaterQualityStation(station);

        ResultInfo info=new ResultInfo();
        if(flag)
        {
            info.setMsg("添加成功！");
        }
        else
        {
            info.setMsg("添加失败，监测站点名已存在！");
        }

        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        System.out.println(info);
        String string = mapper.writeValueAsString(info);
        response.getWriter().write(string);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
