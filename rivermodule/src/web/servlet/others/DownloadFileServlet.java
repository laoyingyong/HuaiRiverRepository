package web.servlet.others;

import domain.WaterLevel;
import service.WaterLevelService;
import service.impl.WaterLevelServiceImpl;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-05 10:27
 */
@WebServlet("/DownloadFileServlet")
public class DownloadFileServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        ServletOutputStream outputStream = response.getOutputStream();//网络字节输出流
        WaterLevelService service=new WaterLevelServiceImpl();
        List<WaterLevel> weekData = service.findWeekData();

        outputStream.write(("河流"+"\t"+"测站名"+"\t"+"时间"+"\t"+"水位"+"\t"+"流量"+"\t"+"超警戒（汛限）水位"+"\n").getBytes());
        outputStream.write("-----------------------------------------最近七天的水位数据-------------------------------------------\n".getBytes());
        for (WaterLevel item : weekData)
        {
            String riverName = item.getRiverName();
            String siteName = item.getSiteName();
            Timestamp collectionDate = item.getCollectionDate();
            SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm");
            String format = simpleDateFormat.format(collectionDate);
            Double waterLevel = item.getWaterLevel();
            Double flow = item.getFlow();
            Double over = item.getOver();

            outputStream.write((riverName+"\t"+siteName+"\t"+format+"\t"+waterLevel+"\t"+flow+"\t"+over+"\n").getBytes());


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
