package web.servlet.waterLevel;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.WaterLevel;
import service.WaterLevelService;
import service.impl.WaterLevelServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-06 12:43
 */
@WebServlet("/FindBySiteNameServlet")
public class FindBySiteNameServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String siteName = request.getParameter("siteName");
        WaterLevelService service=new WaterLevelServiceImpl();
        List<WaterLevel> list = service.findBySiteName(siteName);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset=utf-8");
        mapper.writeValue(response.getOutputStream(),list);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
