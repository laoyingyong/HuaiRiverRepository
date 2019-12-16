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

@WebServlet("/AddWaterLevelDataServlet")
public class AddWaterLevelDataServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String name = request.getParameter("name");
        String waterLevel = request.getParameter("waterLevel");
        String over = request.getParameter("over");
        String status = request.getParameter("status");
        String collectionDate = request.getParameter("collectionDate");

        WaterLevel waterLevelObj=new WaterLevel();

        try {
            waterLevelObj.setName(name);
            waterLevelObj.setWaterLevel(Double.parseDouble(waterLevel));
            waterLevelObj.setOver(Double.parseDouble(over));
            waterLevelObj.setStatus(status);
            waterLevelObj.setCollectionDate(Date.valueOf(collectionDate));
        } catch (NumberFormatException e) {
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
