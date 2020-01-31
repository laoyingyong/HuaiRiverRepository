package web.servlet.waterQuality;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import domain.WaterQuality;
import service.WaterQualityService;
import service.impl.WaterQualityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

/**
 * @author laoyingyong
 * @date: 2020-01-29 22:18
 */
@WebServlet("/UpdateWaterQualityInfoServlet")
public class UpdateWaterQualityInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String id = request.getParameter("id");
        String belongStation = request.getParameter("belongStation");
        String ph = request.getParameter("ph");
        String oxygen = request.getParameter("oxygen");
        String nitrogen = request.getParameter("nitrogen");
        String permangan = request.getParameter("permangan");
        String orgacarbon = request.getParameter("orgacarbon");
        String level = request.getParameter("phquality");
        String time = request.getParameter("time");
        WaterQualityService service=new WaterQualityServiceImpl();
        WaterQuality waterQuality=new WaterQuality();

        try
        {

            waterQuality.setId(Integer.parseInt(id));
            waterQuality.setBelongStation(belongStation);
            waterQuality.setpH(Double.parseDouble(ph));
            waterQuality.setdO(Double.parseDouble(oxygen));
            waterQuality.setnH4(Double.parseDouble(nitrogen));
            waterQuality.setcODMn(Double.parseDouble(permangan));
            waterQuality.setLevel(level);
            waterQuality.setDateTime(Timestamp.valueOf(time+":00"));
            waterQuality.settOC(Double.parseDouble(orgacarbon));
        } catch (Exception e)
        {
            System.out.println(e);
        }

        boolean update = service.update(waterQuality);
        ResultInfo info=new ResultInfo();
        if(update)
        {
            info.setMsg("更新成功！");
        }
        else
        {
            info.setMsg("更新失败！");
        }
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset=utf-8");
        mapper.writeValue(response.getOutputStream(),info);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
