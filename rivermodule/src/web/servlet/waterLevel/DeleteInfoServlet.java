package web.servlet.waterLevel;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import service.WaterLevelService;
import service.impl.WaterLevelServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteInfoServlet")
public class DeleteInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String id = request.getParameter("id");
        WaterLevelService service=new WaterLevelServiceImpl();
        boolean b = service.deleteInfo(Integer.parseInt(id));

        ResultInfo info=new ResultInfo();
        if(b)
        {
            info.setMsg("删除成功！请刷新数据！");
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
