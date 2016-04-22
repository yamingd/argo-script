package com.{{prj._company_}}.{{prj._project_}}.web.home.{{_module_}};

import com.argo.db.exception.EntityNotFoundException;
import com.argo.service.ServiceException;
import com.argo.collection.Pagination;
import com.argo.web.JsonResponse;
import com.argo.web.Enums;
import com.argo.security.UserIdentity;

import com.{{prj._company_}}.{{prj._project_}}.web.home.HomeBaseController;
import {{ _tbi_.java.model_ns }}.{{_tbi_.java.name}};
import {{ _tbi_.java.service_ns }}.{{_tbi_.java.name}}Service;
import com.{{prj._company_}}.{{prj._project_}}.ErrorCodes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import javax.validation.Valid;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by {{_user_}}.
 */
@Controller
@RequestMapping("/{{_tbi_.mvc_url()}}/")
public class Home{{_tbi_.java.name}}Controller extends HomeBaseController {
	
    @Autowired
    private {{_tbi_.java.name}}Service {{_tbi_.java.varName}}Service;
    
    @RequestMapping(value="{page}/{start}", method = RequestMethod.GET)
    public ModelAndView all(ModelAndView model, HttpServletRequest request, HttpServletResponse response,
                            @PathVariable Integer page,
                            @PathVariable Integer start) throws Exception {

        UserIdentity user = getCurrentUser();                    
        Pagination<{{_tbi_.java.name}}> result = new Pagination<{{_tbi_.java.name}}>();
        result.setIndex(page);
        result.setSize(20);

        //TODO: service function

        model.setViewName("/home/{{_tbi_.mvc_url()}}/list");
        model.addObject("items", result);

        return model;
    }

    @RequestMapping(value="0", method = RequestMethod.GET)
    public ModelAndView add(ModelAndView model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        model.setViewName("/home/{{_tbi_.mvc_url()}}/add");
        model.addObject("item", new {{_tbi_.java.name}}());

        return model;
    }

    @RequestMapping(value="{id}", method = RequestMethod.GET)
    public ModelAndView view(ModelAndView model, @PathVariable {{_tbi_.pk.java.typeName}} id, HttpServletRequest request, HttpServletResponse response) throws Exception {

        UserIdentity user = getCurrentUser();

        {{_tbi_.java.name}} item = {{_tbi_.java.varName}}Service.find(user, id);
        model.addObject("item", item);
        model.setViewName("/home/{{_tbi_.mvc_url()}}/view");

        return model;
    }

    @RequestMapping(value="0", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse postCreate(@Valid Home{{_tbi_.java.name}}Form form, BindingResult result, JsonResponse actResponse) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse;
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.java.name}} item = form.to();
        item = {{_tbi_.java.varName}}Service.create(user, item);

        actResponse.add(item);

        return actResponse;
    }

    @RequestMapping(value="{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse postSave(@Valid Home{{_tbi_.java.name}}Form form, BindingResult result, @PathVariable {{_tbi_.pk.java.typeName}} id, JsonResponse actResponse) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse;
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.java.name}} item = form.to();
        item.set{{_tbi_.pk.java.setterName}}(id);

        {{_tbi_.java.varName}}Service.save(user, item);

        return actResponse;
    }

    @RequestMapping(value="{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse postRemove(@PathVariable {{_tbi_.pk.java.typeName}} id, JsonResponse actResponse) throws Exception {

        UserIdentity user = getCurrentUser();

        {{_tbi_.java.varName}}Service.removeBy(user, id);

        return actResponse;
    }
    
}