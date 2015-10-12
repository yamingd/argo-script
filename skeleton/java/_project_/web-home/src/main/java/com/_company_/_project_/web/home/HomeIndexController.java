package com._company_._project_.web.home;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * Created by yamingd on 9/8/15.
 */
@Controller
@RequestMapping("/")
public class HomeIndexController extends HomeBaseController {


    @Override
    public boolean needLogin() {
        return false;
    }

    @RequestMapping(value = "/", method= RequestMethod.GET)
    public String get(){
        return "home/index";
    }

}
