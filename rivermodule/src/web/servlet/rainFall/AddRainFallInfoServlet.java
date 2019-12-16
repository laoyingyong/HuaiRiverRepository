package web.servlet.rainFall;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.RainFall;
import domain.ResultInfo;
import service.RainFallService;
import service.impl.RainFallServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/AddRainFallInfoServlet")
public class AddRainFallInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String area = request.getParameter("area");
        String precipitation = request.getParameter("precipitation");
        String month = request.getParameter("month");
        String releaseDate = request.getParameter("releaseDate");


        RainFall rainFall=new RainFall();

        try {
            rainFall.setArea(area);
            rainFall.setPrecipitation(Double.parseDouble(precipitation));
            rainFall.setMonth(Integer.parseInt(month));
            rainFall.setReleaseDate(Date.valueOf(releaseDate));
        } catch (NumberFormatException e) {
            System.out.println(e);
        }

        RainFallService service=new RainFallServiceImpl();
        boolean b = service.addRainFallInfo(rainFall);
        ResultInfo info=new ResultInfo();
        if(b)
        {
            info.setMsg("添加成功！");
        }
        else
        {
            info.setMsg("添加失败，请核对输入数据！");
        }
        response.setContentType("application/json;charset=utf-8");
        ObjectMapper mapper=new ObjectMapper();
        mapper.writeValue(response.getOutputStream(),info);//将数据写回客户端

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
