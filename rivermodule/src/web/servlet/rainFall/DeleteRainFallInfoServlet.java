package web.servlet.rainFall;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import service.RainFallService;
import service.impl.RainFallServiceImpl;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteRainFallInfoServlet")
public class DeleteRainFallInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String id = request.getParameter("id");
        RainFallService service=new RainFallServiceImpl();
        boolean b = service.deleteInfo(Integer.parseInt(id));

        ResultInfo info=new ResultInfo();
        if(b)
        {
            info.setMsg("删除成功!");
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
