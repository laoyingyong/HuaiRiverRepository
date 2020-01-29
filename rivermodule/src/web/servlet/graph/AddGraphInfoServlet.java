package web.servlet.graph;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.Graph;
import domain.ResultInfo;
import service.GraphService;
import service.impl.GraphServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddGraphInfoServlet")
public class AddGraphInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String geo = request.getParameter("geo");
        System.out.println("地理坐标："+geo);
        String att = request.getParameter("att");
        System.out.println("属性是"+att);



        String[] splitArray = att.split(",");
        String name = splitArray[0];
        String city = splitArray[1];

        Graph graph=new Graph();
        graph.setName(name);
        graph.setCity(city);
        graph.setGeometry(geo);


        GraphService service=new GraphServiceImpl();
        boolean b = service.addInfo(graph);

        ResultInfo info=new ResultInfo();
        if(b)
        {
            info.setMsg("保存成功！");
        }
        else
        {
            info.setMsg("保存失败！");
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
