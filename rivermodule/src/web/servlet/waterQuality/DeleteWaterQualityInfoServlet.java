package web.servlet.waterQuality;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import service.WaterQualityService;
import service.impl.WaterQualityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author laoyingyong
 * @date: 2020-01-29 23:22
 */
@WebServlet("/DeleteWaterQualityInfoServlet")
public class DeleteWaterQualityInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String id = request.getParameter("id");
        WaterQualityService service=new WaterQualityServiceImpl();
        int i=0;
        try
        {
            i = Integer.parseInt(id);
        } catch (NumberFormatException e)
        {
            System.out.println(e);
        }
        boolean del = service.del(i);
        ResultInfo info=new ResultInfo();
        if(del)
        {
            info.setMsg("删除成功！");

        }
        else
        {
            info.setMsg("删除失败！");
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
