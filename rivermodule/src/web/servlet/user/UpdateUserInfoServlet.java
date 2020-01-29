package web.servlet.user;

import com.fasterxml.jackson.databind.ObjectMapper;
import domain.ResultInfo;
import domain.User;
import service.UserService;
import service.impl.UserServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author laoyingyong
 * @date: 2020-01-22 19:01
 */
@WebServlet("/UpdateUserInfoServlet")
public class UpdateUserInfoServlet extends HttpServlet
{
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String age = request.getParameter("age");
        String address = request.getParameter("address");
        String qq = request.getParameter("qq");
        String email = request.getParameter("email");


        User user=new User();
        try
        {
            user.setId(Integer.parseInt(id));
            user.setName(name);
            user.setGender(gender);
            user.setAge(Integer.parseInt(age));
            user.setAddress(address);
            user.setQq(qq);
            user.setEmail(email);
        } catch (Exception e)
        {
            System.out.println(e);
        }


        UserService service=new UserServiceImpl();
        boolean b = service.updateUserInfo(user);
        ResultInfo info=new ResultInfo();
        if(b)
        {
            info.setMsg("修改成功，下次登录后即可查看更新！");
        }
        else
        {
            info.setMsg("修改失败！");
        }

        ObjectMapper mapper=new ObjectMapper();
        response.setContentType("application/json;charset=utf8");
        mapper.writeValue(response.getOutputStream(),info);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {

        this.doPost(request, response);

    }
}
