package web.servlet.waterQuality;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import domain.WaterQuality;
import org.apache.commons.beanutils.BeanUtils;
import service.WaterQualityService;
import service.impl.WaterQualityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.sql.Date;
import java.sql.Time;
import java.util.Map;

@WebServlet("/AddWaterQualityInfoServlet")
public class AddWaterQualityInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        WaterQualityService service=new WaterQualityServiceImpl();
        request.setCharacterEncoding("utf-8");
        String belongStation = request.getParameter("belongStation");
        String ph = request.getParameter("ph");
        String oxygen = request.getParameter("oxygen");
        String nitrogen = request.getParameter("nitrogen");
        String permangan = request.getParameter("permangan");
        String orgacarbon = request.getParameter("orgacarbon");
        String waterQuality1 = request.getParameter("waterQuality");
        String date = request.getParameter("date");
        String time = request.getParameter("time");

        WaterQuality waterQuality=new WaterQuality();

        try {
            waterQuality.setBelongStation(belongStation);
            waterQuality.setPh(Double.parseDouble(ph));
            waterQuality.setOxygen(Double.parseDouble(oxygen));
            waterQuality.setNitrogen(Double.parseDouble(nitrogen));
            waterQuality.setPermangan(Double.parseDouble(permangan));
            waterQuality.setOrgacarbon(Double.parseDouble(orgacarbon));
            waterQuality.setPhquality(waterQuality1);
            waterQuality.setDate(Date.valueOf(date));
            waterQuality.setTime(Time.valueOf(time));
        } catch (Exception e) {
            System.out.println(e);
        }
        System.out.println(waterQuality);

        service.addWaterQualityInfo(waterQuality);


        ResultInfo info=new ResultInfo();
        boolean flag = service.addWaterQualityInfo(waterQuality);
        if(flag)
        {
            info.setMsg("添加成功！");
        }
        else
        {
            info.setMsg("添加失败,请核对输入数据是否有误！");
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
