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
 * @date: 2020-01-20 16:01
 */
@WebServlet("/AddOneWaterQualityServlet")
public class AddOneWaterQualityServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        WaterQualityService service=new WaterQualityServiceImpl();
        String belongStation = request.getParameter("belongStation");
        String dateTime = request.getParameter("date");
        System.out.println(dateTime);
        String pH = request.getParameter("ph");
        String oxygen = request.getParameter("oxygen");
        String nitrogen = request.getParameter("nitrogen");
        String permangan = request.getParameter("permangan");
        String orgacarbon = request.getParameter("orgacarbon");
        String level = request.getParameter("waterQuality");

        WaterQuality waterQuality=new WaterQuality();
        try
        {
            if(belongStation!=null&&!belongStation.equals(""))
            waterQuality.setBelongStation(belongStation);
            if(dateTime!=null&&!dateTime.equals(""))
            {waterQuality.setDateTime(Timestamp.valueOf(dateTime.replace("T"," ")+":00"));}
            if(pH!=null&&!pH.equals(""))
            {waterQuality.setpH(Double.parseDouble(pH));}
            if(oxygen!=null&&!oxygen.equals(""))
            {waterQuality.setdO(Double.parseDouble(oxygen));}
            if(nitrogen!=null&&!nitrogen.equals(""))
            {waterQuality.setnH4(Double.parseDouble(nitrogen));}
            if(permangan!=null&&!permangan.equals(""))
            {waterQuality.setcODMn(Double.parseDouble(permangan));}
            if(orgacarbon!=null&&!orgacarbon.equals(""))
            {waterQuality.settOC(Double.parseDouble(orgacarbon));}
            if (level!=null&&!level.equals(""))
            {waterQuality.setLevel(level);}

        } catch (Exception e)
        {
            System.out.println(e);
        }finally
        {

            boolean b = service.addOne(waterQuality);
            ResultInfo info=new ResultInfo();
            if (b)
            {
                info.setMsg("添加成功！");
            }
            else
            {
                info.setMsg("添加失败！");
            }

            ObjectMapper mapper=new ObjectMapper();
            response.setContentType("application/json;charset=utf8");
            mapper.writeValue(response.getOutputStream(),info);

        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
