package com.{{prj._company_}}.{{prj._project_}}.web.admin.{{_module_}};

import com.argo.db.exception.EntityNotFoundException;
import com.argo.web.JsonResponse;
import com.argo.collection.Pagination;

import com.{{prj._company_}}.{{prj._project_}}.web.admin.AdminBaseController;
import com.{{prj._company_}}.{{prj._project_}}.model.{{_module_}}.{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.service.{{_module_}}.{{_tbi_.entityName}}Service;
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
 * Created by {{_user_}} on {{_now_}}.
 */

@Controller
@RequestMapping("/a/{{_tbi_.mvc_url()}}s")
public class Admin{{_tbi_.entityName}}Controller extends AdminBaseController {
	
	@Autowired
    private {{_tbi_.entityName}}Service {{_tbi_.varName}}Service;
    
    @RequestMapping(value="{page}", method = RequestMethod.GET)
    public ModelAndView all(ModelAndView model, HttpServletRequest request, HttpServletResponse response,
                            @PathVariable Integer page){

        UserIdentity user = getCurrentUser();                    
        Pagination<{{_tbi_.entityName}}> result = new Pagination<{{_tbi_.entityName}}>();
        result.setIndex(page);
        result.setSize(20);

        //TODO: service function

        model.setViewName("/admin/{{_mvcurl_}}/list");
        model.addObject("items", result);

        return model;
    }

	@RequestMapping(value="/", method = RequestMethod.GET)
    public ModelAndView add(ModelAndView model, HttpServletRequest request, HttpServletResponse response){

        model.setViewName("/admin/{{_mvcurl_}}/add");
        model.addObject("{{_tbi_.entityName}}", new {{_tbi_.entityName}}());

        return model;
    }

    @RequestMapping(value="{id}", method = RequestMethod.GET)
    public ModelAndView view(ModelAndView model, @PathVariable {{_tbi_.pkType}} id, HttpServletRequest request, HttpServletResponse response){

        UserIdentity user = getCurrentUser();

        try {
            {{_tbi_.entityName}} item = {{_tbi_.varName}}Service.find(user, id);
            model.addObject("item", item);
            model.setViewName("/admin/{{_mvcurl_}}/view");
        } catch (EntityNotFoundException e) {
            RedirectView view = new RedirectView("404");
            model.setView(view);
        }

        return model;
    }

    @RequestMapping(value="/", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse postCreate(@Valid Admin{{_tbi_.entityName}}Form form, BindingResult result, JsonResponse actResponse) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse;
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.entityName}} item = form.to();
        item = {{_tbi_.varName}}Service.create(user, item);

        actResponse.add(item);

        return actResponse;
    }

    @RequestMapping(value="{id}", method = RequestMethod.PUT, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse postSave(@Valid Admin{{_tbi_.entityName}}Form form, BindingResult result, @PathVariable {{_tbi_.pkType}} id, JsonResponse actResponse) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse;
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.entityName}} item = form.to();
        item.setId(id);

        {{_tbi_.varName}}Service.save(user, item);

        return actResponse;
    }

    @RequestMapping(value="{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse postRemove(@PathVariable {{_tbi_.pkType}} id, JsonResponse actResponse) throws Exception {

        UserIdentity user = getCurrentUser();

        {{_tbi_.varName}}Service.removeBy(user, id);

        return actResponse;
    }
    
}