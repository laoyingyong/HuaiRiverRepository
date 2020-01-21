package web.servlet.waterLevel;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import domain.WaterLevel;
import service.WaterLevelService;
import service.impl.WaterLevelServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet("/AddWaterLevelDataServlet")
public class AddWaterLevelDataServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String riverName = request.getParameter("riverName");
        String siteName = request.getParameter("siteName");
        String collectionDate = request.getParameter("collectionDate");
        System.out.println(collectionDate);
        String waterLevel = request.getParameter("waterLevel");
        String flow = request.getParameter("flow");
        String over = request.getParameter("over");


        WaterLevel waterLevelObj=new WaterLevel();

        try
        {
            if(riverName!=null&&riverName.length()!=0)
            {waterLevelObj.setRiverName(riverName);}
            if (siteName!=null&&siteName.length()!=0)
            {waterLevelObj.setSiteName(siteName);}
            String date="";
            if(collectionDate!=null&&collectionDate.length()!=0)
            {
                date=collectionDate.replace("T"," ")+":00";//多出来一个T,必须去掉
                waterLevelObj.setCollectionDate(Timestamp.valueOf(date));
            }
            if(waterLevel!=null&&waterLevel.length()!=0)
            {waterLevelObj.setWaterLevel(Double.parseDouble(waterLevel));}
            if(flow!=null&&flow.length()!=0)
            {waterLevelObj.setFlow(Double.parseDouble(flow));}
            if(over!=null&&over.length()!=0)
            { waterLevelObj.setOver(Double.parseDouble(over));}

        } catch (Exception e)
        {
            System.out.println(e);
        }

        WaterLevelService service=new WaterLevelServiceImpl();
        boolean b = service.addWaterLevelInfo(waterLevelObj);
        ResultInfo info=new ResultInfo();
        if(b)
        {
            info.setMsg("添加成功！");
        }
        else
        {
            info.setMsg("添加失败，请核对输入数据是否有误！");
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
