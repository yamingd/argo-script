package com._company_._project_.web.admin;

import com.argo.security.exception.UnauthorizedException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by yamingd on 9/8/15.
 */
@Controller
@RequestMapping("/a/")
public class AdminIndexController extends AdminBaseController {


    @Override
    public boolean needLogin() {
        return false;
    }

    @RequestMapping(value = "/", method= RequestMethod.GET)
    public String get(){
        try {
            this.getCurrentUser();
            return "admin/index";
        } catch (UnauthorizedException e) {
            //return "admin/signin";
            return "admin/session";
        }
    }
}
