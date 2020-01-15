package web.servlet.waterLevel;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.CurrentWaterLevel;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-01-13 14:51
 */
@WebServlet("/CurrentWaterLevelServlet")
public class CurrentWaterLevelServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        Document document = Jsoup.parse(new URL("http://www.hrc.gov.cn/swj/"), 5000);
        Elements elements = document.select("[class=shuiqing_table] tr");

        List<CurrentWaterLevel> list=new ArrayList<>();
        for (Element element : elements)//遍历所有行
        {
            System.out.println(element.text());
            CurrentWaterLevel currentWaterLevel=new CurrentWaterLevel();
            Elements tds = element.select("td");
            currentWaterLevel.setRiverName(tds.get(0).text());
            currentWaterLevel.setStationName(tds.get(1).text());
            try
            {
                currentWaterLevel.setDate(tds.get(2).text());
                currentWaterLevel.setWaterLevel(Double.parseDouble(tds.get(3).text()));
                String liuliang=tds.get(4).text();
                if(liuliang.length()!=0&&!liuliang.equals(""))//流量比较特殊，可能淮河水文局网站上没有给出数据
                {
                    currentWaterLevel.setFlow(Double.parseDouble(tds.get(4).text()));
                }
                currentWaterLevel.setOver(Double.parseDouble(tds.get(5).text()));
            } catch (Exception e)
            {
                System.out.println(e);
            }
            list.add(currentWaterLevel);

        }
        System.out.println(list);
        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),list);


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
