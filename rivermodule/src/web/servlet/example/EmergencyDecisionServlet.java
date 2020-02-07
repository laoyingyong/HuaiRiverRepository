package web.servlet.example;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Example;
import service.ExampleService;
import service.impl.ExampleServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-05 15:52
 */
@WebServlet("/EmergencyDecisionServlet")
public class EmergencyDecisionServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        request.setCharacterEncoding("utf-8");
        String type = request.getParameter("type");
        String source = request.getParameter("source");
        String multiple = request.getParameter("multiple");
        String distance = request.getParameter("distance");
        String toxicity = request.getParameter("toxicity");
        String danger = request.getParameter("danger");
        String stability = request.getParameter("stability");
        String solubility = request.getParameter("solubility");
        String volatility = request.getParameter("volatility");
        double v=0;
        if(multiple!=null&&!multiple.equals(""))
        {v = Double.parseDouble(multiple);}
        int i=0;
        if(distance!=null&&!distance.equals(""))
        {i = Integer.parseInt(distance);}
        ExampleService service=new ExampleServiceImpl();
        List<Example> resembleExamples = service.findResembleExamples(type, source, v, i, toxicity, danger, stability, solubility, volatility);
        response.setContentType("application/json;chartset=utf-8");
        ObjectMapper mapper=new ObjectMapper();
        mapper.writeValue(response.getOutputStream(),resembleExamples);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
