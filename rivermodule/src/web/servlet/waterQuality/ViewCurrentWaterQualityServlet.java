package web.servlet.waterQuality;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.databind.ObjectMapper;
import domain.WaterQuality;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-01-19 15:20
 */
@WebServlet("/ViewCurrentWaterQualityServlet")
public class ViewCurrentWaterQualityServlet extends HttpServlet
{
    private List<WaterQuality> qualityList;
    private static String [] siteArray={"江苏邳苍","江苏泗洪大屈","江苏盱眙","江苏徐州李集桥",
            "安徽蚌埠蚌埠闸","安徽亳州颜集","安徽滁州小柳巷","安徽阜南王家坝","安徽阜阳徐庄",
            "安徽阜阳张大桥","安徽淮北小王桥","安徽界首七渡口","山东临沂涝沟桥","山东枣庄台儿庄",
            "河南信阳淮滨水文站","河南永城黄口","河南周口鹿邑付桥闸","河南驻马店班台"};//官网只给出这18个淮河站的水质数据
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        //参数字符串，如果拼接在请求链接之后，需要对中文进行 URLEncode   字符集 UTF-8
        String param = "Method=SelectRealData";
        StringBuilder sb = new StringBuilder();
        InputStream is = null;
        BufferedReader br = null;
        PrintWriter out = null;
        try
        {
            //接口地址
            String url = "http://123.127.175.45:8082/ajax/GwtWaterHandler.ashx";
            URL uri = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) uri.openConnection();
            connection.setRequestMethod("POST");
            connection.setReadTimeout(5000);
            connection.setConnectTimeout(10000);
            connection.setRequestProperty("accept", "*/*");
            //发送参数
            connection.setDoOutput(true);
            out = new PrintWriter(connection.getOutputStream());
            out.print(param);
            out.flush();
            //接收结果
            is = connection.getInputStream();
            br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            String line;
            //缓冲逐行读取
            while ((line = br.readLine()) != null)
            {
                sb.append(line);
            }
            String backStr = sb.toString();
            System.out.println(backStr);
            JSONArray jsonArray = JSONObject.parseArray(backStr);

            qualityList=new LinkedList<>();

            for (int i = 0; i < jsonArray.size(); i++)
            {
                WaterQuality waterQuality=new WaterQuality();
                JSONObject jsonObject = jsonArray.getJSONObject(i);
                String siteName = jsonObject.getString("siteName");
                boolean b = Arrays.asList(siteArray).contains(siteName);
                String dateTime = jsonObject.getString("dateTime");
                String pH = jsonObject.getString("pH");
                String aDo = jsonObject.getString("DO");
                String nh4 = jsonObject.getString("NH4");
                String codMn = jsonObject.getString("CODMn");
                String toc = jsonObject.getString("TOC");
                String level = jsonObject.getString("level");
                if (b)
                {
                    System.out.print(siteName+"\t");
                    System.out.print(dateTime+"\t");
                    System.out.print(pH+"\t");
                    System.out.print(aDo+"\t");
                    System.out.print(nh4+"\t");
                    System.out.print(codMn+"\t");
                    System.out.print(toc+"\t");
                    System.out.println(level);

                    waterQuality.setBelongStation(siteName);
                    waterQuality.setDateTime(dateTime);
                    if(!pH.equals("--"))
                    waterQuality.setpH(Double.parseDouble(pH));
                    if(!aDo.equals("--"))
                    waterQuality.setdO(Double.parseDouble(aDo));
                    if(!nh4.equals("--"))
                    waterQuality.setnH4(Double.parseDouble(nh4));
                    if(!codMn.equals("--"))
                    waterQuality.setcODMn(Double.parseDouble(codMn));
                    if(!toc.equals("--"))
                    waterQuality.settOC(Double.parseDouble(toc));
                    if(!level.equals("--"))
                    waterQuality.setLevel(level);
                    qualityList.add(waterQuality);

                }


            }





        } catch (Exception e)
        {
            System.out.println(e);
        } finally
        {
            ObjectMapper mapper=new ObjectMapper();
            response.setContentType("application/json;charset=utf8");
            System.out.println(qualityList);
            mapper.writeValue(response.getOutputStream(),qualityList);

            //关闭流
            try {
                if (is != null)
                {
                    is.close();
                }
                if (br != null)
                {
                    br.close();
                }
                if (out != null)
                {
                    out.close();
                }
            } catch (Exception ignored)
            {
                System.out.println(ignored);
            }

        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
