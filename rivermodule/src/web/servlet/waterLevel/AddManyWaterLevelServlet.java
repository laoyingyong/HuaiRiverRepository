package web.servlet.waterLevel;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import domain.WaterLevel;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import service.WaterLevelService;
import service.impl.WaterLevelServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URL;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-01-20 20:46
 */
@WebServlet("/AddManyWaterLevelServlet")
public class AddManyWaterLevelServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        int i=0;
        WaterLevelService service=new WaterLevelServiceImpl();

        Document document = Jsoup.parse(new URL("http://www.hrc.gov.cn/swj/"), 5000);
        Elements elements = document.select("[class=shuiqing_table] tr");

        List<WaterLevel> list=new ArrayList<>();
        for (Element element : elements)//遍历所有行
        {
            System.out.println(element.text());
            WaterLevel waterLevel=new WaterLevel();
            Elements tds = element.select("td");
            waterLevel.setRiverName(tds.get(0).text());
            waterLevel.setSiteName(tds.get(1).text());
            try
            {
                String str=tds.get(2).text()+":00";
                waterLevel.setCollectionDate(Timestamp.valueOf(str));
                waterLevel.setWaterLevel(Double.parseDouble(tds.get(3).text()));
                String liuliang=tds.get(4).text();
                if(liuliang.length()!=0&&!liuliang.equals(""))//流量比较特殊，可能淮河水文局网站上没有给出数据
                {
                    waterLevel.setFlow(Double.parseDouble(tds.get(4).text()));
                }
                waterLevel.setOver(Double.parseDouble(tds.get(5).text()));
            } catch (Exception e)
            {
                System.out.println(e);
            }
            list.add(waterLevel);

        }
        i = service.addManyLevel(list);
        System.out.println(list);
        ObjectMapper mapper=new ObjectMapper();
        ResultInfo info=new ResultInfo();
        info.setMsg("总共同步了"+i+"条数据");
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),info);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
