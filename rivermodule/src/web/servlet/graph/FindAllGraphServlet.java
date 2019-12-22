package web.servlet.graph;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Graph;
import service.GraphService;
import service.impl.GraphServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/FindAllGraphServlet")
public class FindAllGraphServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String type = request.getParameter("type");
        System.out.println(type);
        String table = request.getParameter("table");
        System.out.println(table);

        GraphService service=new GraphServiceImpl();
        List<Graph> list = service.queryInfo();

        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),list);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
