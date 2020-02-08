package web.servlet.waterQualityStation;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.StationAndQuality;
import service.WaterQualityStationService;
import service.impl.WaterQualityStationServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-08 11:32
 */
@WebServlet("/IndexingServlet")
public class IndexingServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        WaterQualityStationService service=new WaterQualityStationServiceImpl();
        List<StationAndQuality> list = service.indexing();
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;chartset-utf-8");
        mapper.writeValue(response.getOutputStream(),list);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
