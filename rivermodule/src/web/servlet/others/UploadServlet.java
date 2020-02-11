package web.servlet.others;

import domain.WaterQuality;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import service.WaterQualityService;
import service.impl.WaterQualityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

/**
 * @author laoyingyong
 * @date: 2020-02-11 12:12
 */
@WebServlet("/UploadServlet")
public class UploadServlet extends HttpServlet
{


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        int count=0;
        WaterQualityService service=new WaterQualityServiceImpl();


        request.setCharacterEncoding("UTF-8");
        //String type=request.getParameter("type");

        try {
            // 配置上传参数
            DiskFileItemFactory factory = new DiskFileItemFactory();
            ServletFileUpload upload = new ServletFileUpload(factory);
            // 解析请求的内容提取文件数据
            @SuppressWarnings("unchecked")
            List<FileItem> formItems = upload.parseRequest(request);


            // 迭代表单数据
            for (FileItem item : formItems)
            {
                // 处理不在表单中的字段
                if (!item.isFormField())
                {
                    String fileName = item.getName(); //获取上传的文件名
                    String fileType=fileName.substring(fileName.lastIndexOf(".")+1);
                    //定义上传文件的存放路径
                    String path = request.getServletContext().getRealPath("/upload");
                    //定义上传文件的完整路径
                    fileName= new SimpleDateFormat("yyyyMMddhhmmss").format(new Date()).toString();
                    fileName+="."+fileType;  //将文件名字改为时间，避免重名文件
                    String filePath = String.format("%s\\%s",path,fileName);
                    File storeFile = new File(filePath);
                    // 在控制台输出文件的上传路径
                    System.out.println(path);
                    System.out.println(filePath);

                    // 保存文件到硬盘
                    item.write(storeFile);

                    BufferedReader bufferedReader=new BufferedReader(new InputStreamReader(new FileInputStream(filePath),"utf-8"));//缓冲字符输入流、转换流
                    String line=null;

                    while((line=bufferedReader.readLine())!=null)
                    {
                        //System.out.println(line);
                        String[] split = line.split("\t");
                        System.out.println(Arrays.toString(split));
                        WaterQuality waterQuality=new WaterQuality();
                        try
                        {
                            waterQuality.setBelongStation(split[0]);
                            waterQuality.setDateTime(Timestamp.valueOf(split[1]+":00"));
                            if(!split[2].equals("null"))
                            {waterQuality.setpH(Double.parseDouble(split[2]));}
                            if(!split[3].equals("null"))
                            {waterQuality.setdO(Double.parseDouble(split[3]));}
                            if(!split[4].equals("null"))
                            {waterQuality.setnH4(Double.parseDouble(split[4]));}
                            if(!split[5].equals("null"))
                            {waterQuality.setcODMn(Double.parseDouble(split[5]));}
                            if(!split[6].equals("null"))
                            {waterQuality.settOC(Double.parseDouble(split[6]));}
                            if(!split[7].equals("null"))
                            {waterQuality.setLevel(split[7]);}
                        } catch (Exception e)
                        {
                            System.out.println(e);
                        }
                        boolean b = service.addOne(waterQuality);
                        if(b)
                        {
                            count++;
                        }
                    }
                }
            }
        } catch (FileUploadException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }


        request.setAttribute("message",count);
        // 跳转到 message.jsp
        getServletContext().getRequestDispatcher("/message.jsp").forward(
                request, response);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
