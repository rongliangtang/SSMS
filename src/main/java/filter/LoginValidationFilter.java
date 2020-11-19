package filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginValidationFilter implements Filter {
    protected FilterConfig filterConfig;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req=(HttpServletRequest)request;
        HttpServletResponse resp=(HttpServletResponse)response;
        HttpSession session=req.getSession();
        String reqURL=req.getServletPath();

//        String[] filterUrl = {"/","/loginPage.jsp","/signUpPage.jsp","/pages/tip/signUpSucess.jsp","/pages/tip/signUpFail.jsp","/pages/tip/signUpFail.jsp","/pages/tip/loginSucess.jsp"};
//        String[] filterInterface = {"/loginCheck","/signUpCheck"};

        //注意！！！
        //对于登录页面loginPage.jsp和不需要验证的一些界面不需要验证
        //访问的接口不需要验证！！！
//        System.out.println(reqURL);
//        if(!(reqURL.equals("/loginPage.jsp") || reqURL.equals("/signUpPage.jsp") || reqURL.equals("/") || reqURL.equals("/pages/tip/signUpSucess.jsp") || reqURL.equals("/pages/tip/signUpFail.jsp") || reqURL.equals("/pages/tip/loginSucess.jsp") || reqURL.equals("/pages/tip/loginFail.jsp") || reqURL.equals("/signUpCheck") || reqURL.equals("/loginCheck"))) {
//            //假定session存储的正确登录信息为（"username","xxx"）
//            if(session.getAttribute("username")==null) {
//                resp.sendRedirect("/loginPage.jsp");
//                return;
//            }
//        }


        //注意，filter会过滤所有的请求，包括文件中加载的js、css等路径，包括servlet的接口url都会被拦截
        //在web.xml配置中，我们设置只拦截.jsp后缀的路径，servlet安全控制在servlet里面写
        if (session.getAttribute("username") != null){
            //登录后，session里面有信息，再访问登录或注册界面的时候自动跳到mainpage
            if (reqURL.equals("/loginPage.jsp") || reqURL.equals("/signUpPage.jsp")){
                resp.sendRedirect("/mainPage.jsp");
                return;
            }
            //登录后，才能访问查询信息这些接口

        }else {
            //未登录的时候，session里面没信息，只能访问登录注册界面、登录注册接口，所以访问mainnpage的时候跳转回loginpage
            if (!(reqURL.equals("/") || reqURL.equals("/loginPage.jsp") || reqURL.equals("/signUpPage.jsp"))){
                resp.sendRedirect("/loginPage.jsp");
                return;
            }
        }


        chain.doFilter(request, response);
    }

    public void destroy() {
        filterConfig=null;

    }

    public void init(FilterConfig filterConfig) throws ServletException {
        this.filterConfig=filterConfig;
    }
}

