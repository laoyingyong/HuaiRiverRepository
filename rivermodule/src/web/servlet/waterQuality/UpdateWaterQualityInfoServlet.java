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
import java.sql.Date;
import java.sql.Time;

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
        String phquality = request.getParameter("phquality");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        WaterQuality waterQuality=new WaterQuality();

        try
        {
            waterQuality.setId(Integer.parseInt(id));
            waterQuality.setBelongStation(belongStation);
            waterQuality.setPh(Double.parseDouble(ph));
            waterQuality.setOxygen(Double.parseDouble(oxygen));
            waterQuality.setNitrogen(Double.parseDouble(nitrogen));
            waterQuality.setPermangan(Double.parseDouble(permangan));
            waterQuality.setOrgacarbon(Double.parseDouble(orgacarbon));
            waterQuality.setPhquality(phquality);
            waterQuality.setDate(Date.valueOf(date));
            waterQuality.setTime(Time.valueOf(time));
        } catch (Exception e)
        {
            System.out.println(e);
        }

        WaterQualityService service=new WaterQualityServiceImpl();
        boolean flag = service.update(waterQuality);

        ResultInfo info=new ResultInfo();
        if(flag)
        {
            info.setMsg("修改成功！");
        }
        else
        {
            info.setMsg("修改失败！");
        }
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),info);


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
