package web.filter;

import com.sun.deploy.net.HttpRequest;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@WebFilter("/*")
public class FilterImpl implements Filter
{
    public void destroy()
    {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException
    {
        HttpServletRequest request=(HttpServletRequest)req;
        String requestURI = request.getRequestURI();//获取请求路径
        if(requestURI.contains("/login.jsp")||requestURI.contains("/loginServlet")||requestURI.contains("/css")||requestURI.contains("/js")||requestURI.contains("/img")||requestURI.contains("/checkCodeServlet")||requestURI.contains("/register.jsp")||requestURI.contains("RegisterServlet"))
        {
            chain.doFilter(req, resp);//用户请求上面的资源时，放行，也就是让用户访问上面的资源
        }
        else //用户请求了其他的资源，没有登录的话，肯定是要拦截的，已经登录的话就放行
        {
            Object user = request.getSession().getAttribute("user");
            if(user!=null)//用户登录了，放行
            {
                chain.doFilter(req,resp);

            }
            else //用户没有登录，拦截
                {
                    req.setAttribute("login_msg","您尚未登录，请登录！");
                    req.getRequestDispatcher("/login.jsp").forward(req,resp);

            }


        }

    }

    public void init(FilterConfig config) throws ServletException
    {

    }

}
