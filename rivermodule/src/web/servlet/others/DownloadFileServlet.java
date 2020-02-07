package web.servlet.others;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

/**
 * @author laoyingyong
 * @date: 2020-02-05 10:27
 */
@WebServlet("/DownloadFileServlet")
public class DownloadFileServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String filename = request.getParameter("filename");

        //找到文件在服务器的路径
        ServletContext servletContext = request.getServletContext();
        String realPath = servletContext.getRealPath("/WEB-INF/classes/" + filename);//文件如果直接放在src目录下的话


        //设置响应的mime类型
        String mimeType = servletContext.getMimeType(filename);
        response.setContentType(mimeType);


        String encodeFileName = URLEncoder.encode(filename, "utf-8");//编码，解决文件中文乱码问题
        response.setHeader("content-disposition","attachment;filename="+encodeFileName);

        FileInputStream fileInputStream = new FileInputStream(realPath);//文件字节输入流
        ServletOutputStream outputStream = response.getOutputStream();//网络字节输出流

        byte [] array=new byte[1024];//缓冲数组
        int len=0;//每次读取到的有效字节数
        while((len=fileInputStream.read(array))!=-1)//读取服务器中的文件进内存，并将文件写回给浏览器
        {
            outputStream.write(array,0,len);
        }

        fileInputStream.close();//释放资源

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
