package web.servlet.user;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import domain.User;
import service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String username = request.getParameter("username");
        String newPassword = request.getParameter("newPassword");

        User user=new User();
        user.setUsername(username);
        user.setPassword(newPassword);

        UserServiceImpl service=new UserServiceImpl();
        service.updateUserPassword(user);

        HttpSession session = request.getSession();
        session.removeAttribute("user");

        ResultInfo info=new ResultInfo();
        info.setMsg("密码修改成功！");

        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf-8");
        mapper.writeValue(response.getOutputStream(),info);


    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
