package servlets;

import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ExitSystemServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //将super注释掉就可以解决提交响应后无法转发的问题，但是不知道为什么
//        super.doGet(req, resp);
        resp.setContentType("text/html;charset=UTF-8");

        //接口返回json
        JSONObject jsonObject = null;

        //如果服务器上的session找不到则返回未登录json提示给用户并return
        if (req.getSession().getAttribute("username") == null){
            jsonObject = new JSONObject("{message:'请先登录后再操作'}");
            resp.getOutputStream().write(jsonObject.toString().getBytes("utf-8"));

            return;
        }

        //清空session里面存的属性，清空完成功后退出到登录界面
        req.getSession().removeAttribute("username");
        if (req.getSession().getAttribute("username") == null){
//            req.getRequestDispatcher("/loginPage.jsp").forward(req, resp);
            resp.sendRedirect("/loginPage.jsp");
        }
    }

}
