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

@WebServlet("/UpdateRainFallInfoServlet")
public class UpdateRainFallInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String id = request.getParameter("id");
        System.out.println(id);
        String area = request.getParameter("area");
        String month = request.getParameter("month");
        System.out.println(month);
        String precipitation = request.getParameter("precipitation");
        System.out.println(precipitation);
        String releaseDate = request.getParameter("releaseDate");


        RainFall rainFall=new RainFall();
        try {
            int intId = Integer.parseInt(id);
            int intMonth = Integer.parseInt(month);
            double doublePrecipitation = Double.parseDouble(precipitation);
            Date dateReleaseDate = Date.valueOf(releaseDate);


            rainFall.setId(intId);
            rainFall.setArea(area);
            rainFall.setMonth(intMonth);
            rainFall.setReleaseDate(dateReleaseDate);
            rainFall.setPrecipitation(doublePrecipitation);
        } catch (Exception e) {
            System.out.println(e);
        }

        RainFallService service=new RainFallServiceImpl();
        boolean b = service.updateRainFallInfo(rainFall);
        ResultInfo info=new ResultInfo();
        if(b)
        {
            info.setMsg("更新成功！");
        }
        else
        {
            info.setMsg("更新失败！");
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
