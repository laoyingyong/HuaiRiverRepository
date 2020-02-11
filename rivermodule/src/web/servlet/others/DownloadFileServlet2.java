package web.servlet.others;

import domain.WaterLevel;
import domain.WaterQuality;
import service.WaterLevelService;
import service.WaterQualityService;
import service.impl.WaterLevelServiceImpl;
import service.impl.WaterQualityServiceImpl;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-05 10:27
 */
@WebServlet("/DownloadFileServlet2")
public class DownloadFileServlet2 extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        ServletOutputStream outputStream = response.getOutputStream();//网络字节输出流
        WaterQualityService service=new WaterQualityServiceImpl();
        List<WaterQuality> weekData = service.findWeekData();

        outputStream.write(("测站名"+"\t"+"时间"+"\t"+"PH"+"\t"+"溶解氧"+"\t"+"氨氮"+"\t"+"高猛酸钾盐指数"+"\t"+"总有机碳"+"\t"+"水质类别"+"\n").getBytes());
        outputStream.write("---------------------------------------------------------------最近七天的水质数据--\n".getBytes());
        for (WaterQuality item : weekData)
        {
            String belongStation = item.getBelongStation();

            Timestamp dateTime = item.getDateTime();
            SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm");
            String format = simpleDateFormat.format(dateTime);
            Double aDouble = item.getpH();
            Double aDouble1 = item.getdO();
            Double aDouble2 = item.getnH4();
            Double aDouble3 = item.getcODMn();
            Double aDouble4 = item.gettOC();
            String level = item.getLevel();

            outputStream.write((belongStation+"\t"+format+"\t"+aDouble+"\t"+aDouble1+"\t"+aDouble2+"\t"+aDouble3+"\t"+aDouble4+"\t"+level+"\n").getBytes());


        }


        String filename = request.getParameter("filename");


        ServletContext servletContext = request.getServletContext();

        //设置响应的mime类型
        String mimeType = servletContext.getMimeType(filename);
        response.setContentType(mimeType);


        String encodeFileName = URLEncoder.encode(filename, "utf-8");//编码，解决文件中文乱码问题
        response.setHeader("content-disposition","attachment;filename="+encodeFileName);


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
