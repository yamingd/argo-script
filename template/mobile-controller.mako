package com.{{prj._company_}}.{{prj._project_}}.web.mobile.{{_module_}};


import com.argo.db.exception.EntityNotFoundException;
import com.argo.service.ServiceException;
import com.argo.collection.Pagination;
import com.argo.web.protobuf.PAppResponse;
import com.argo.web.protobuf.ProtobufResponse;
import com.argo.web.Enums;
import com.argo.security.UserIdentity;

import com.{{prj._company_}}.{{prj._project_}}.web.mobile.MobileBaseController;
import com.{{prj._company_}}.{{prj._project_}}.model.{{_module_}}.{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}.PB{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._project_}}.convertor.{{_module_}}.{{_tbi_.entityName}}Convertor;
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
@RequestMapping("/m/{{_tbi_.mvc_url()}}")
public class Mobile{{_tbi_.entityName}}Controller extends MobileBaseController {
    
    @Autowired
    private {{_tbi_.entityName}}Service {{_tbi_.varName}}Service;
    
    @RequestMapping(value="{page}/{ts}", method=RequestMethod.GET, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse list(ProtobufResponse actResponse, @PathVariable Integer page, @PathVariable Long ts) throws Exception {
        Pagination<{{_tbi_.entityName}}> result = new Pagination<{{_tbi_.entityName}}>();
        result.setIndex(page);
        result.setStart(ts);

        //TODO: service function
        UserIdentity user = getCurrentUser();

        for({{_tbi_.entityName}} item : result.getItems()) {
            //convert item to P{{_tbi_.entityName}}
            PB{{_tbi_.entityName}} msg = {{_tbi_.entityName}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        }
        actResponse.getBuilder().setTotal(result.getTotal());
        return actResponse.build();
    }

    @RequestMapping(value="{id}", method=RequestMethod.GET, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse view(ProtobufResponse actResponse, @PathVariable {{_tbi_.pkType}} id) throws Exception {

        UserIdentity user = getCurrentUser();

        try {
            {{_tbi_.entityName}} item = {{_tbi_.varName}}Service.find(user, id);
            //convert item to P{{_tbi_.entityName}}
            PB{{_tbi_.entityName}} msg = {{_tbi_.entityName}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        }catch (EntityNotFoundException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }

    @RequestMapping(value="/", method = RequestMethod.POST, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse postCreate(@Valid Mobile{{_tbi_.entityName}}Form form, BindingResult result, ProtobufResponse actResponse) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse.build();
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.entityName}} item = form.to();

        try{
            item = {{_tbi_.varName}}Service.create(user, item);
            PB{{_tbi_.entityName}} msg = {{_tbi_.entityName}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        } catch (ServiceException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }

    @RequestMapping(value="{id}", method = RequestMethod.PUT, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse postSave(@Valid Mobile{{_tbi_.entityName}}Form form, BindingResult result, @PathVariable {{_tbi_.pkType}} id, ProtobufResponse actResponse) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse.build();
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.entityName}} item = form.to();
        item.setId(id);

        try{
            item = {{_tbi_.varName}}Service.save(user, item);
            PB{{_tbi_.entityName}} msg = {{_tbi_.entityName}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        } catch (ServiceException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }
        
        return actResponse.build();
    }

    @RequestMapping(value="{id}", method = RequestMethod.DELETE, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse postRemove(@PathVariable {{_tbi_.pkType}} id, ProtobufResponse actResponse) throws Exception {

        UserIdentity user = getCurrentUser();

        try{
            {{_tbi_.varName}}Service.removeBy(user, id);
        } catch (ServiceException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }
    
}