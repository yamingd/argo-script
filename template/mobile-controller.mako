package com.{{prj._company_}}.{{prj._project_}}.web.mobile.{{_module_}};

import com.argo.annotation.ApiDoc;
import com.argo.annotation.ApiMethodDoc;
import com.argo.annotation.ApiParameterDoc;
import com.argo.db.exception.EntityNotFoundException;
import com.argo.service.ServiceException;
import com.argo.collection.Pagination;
import com.argo.web.protobuf.PAppResponse;
import com.argo.web.protobuf.ProtobufResponse;
import com.argo.web.Enums;
import com.argo.security.UserIdentity;

import com.{{prj._company_}}.{{prj._project_}}.web.mobile.MobileBaseController;
import com.{{prj._company_}}.{{prj._project_}}.model.{{_module_}}.{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._project_}}.protobuf.{{_module_}}.PB{{_tbi_.java.name}};
import com.{{prj._company_}}.{{prj._project_}}.convertor.{{_module_}}.{{_tbi_.java.name}}Convertor;
import com.{{prj._company_}}.{{prj._project_}}.service.{{_module_}}.{{_tbi_.java.name}}Service;
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
 * 调用业务逻辑实现(service)，获取得到业务代号或业务数据
 * 业务代号存放在model模块 ErrorCodes. 通过返回值或异常代号来抓取
 * 业务数据通常为列表或单体详细
 * Created by {{_user_}} on {{_now_}}.
 */
@ApiDoc("{{ _tbi_.java.name }} HTTP接口")
@Controller
@RequestMapping("/m/{{_tbi_.mvc_url()}}/")
public class Mobile{{_tbi_.java.name}}Controller extends MobileBaseController {
    
    @Autowired
    private {{_tbi_.java.name}}Service {{_tbi_.java.varName}}Service;
    
    /**
     * @param actResponse 默认参数. {@link ProtobufResponse}
     * @return 返回实体. {@link PB{{_tbi_.java.name}}}
     * @throws Exception 这里抛出无法预测的异常. 业务异常都要处理，把异常的业务代号发回移动端
     */
    @ApiMethodDoc(value = "读取{{ _tbi_.java.name }}列表", returnClass = PB{{_tbi_.java.name}}.class)
    @RequestMapping(value="{page}/{ts}", method=RequestMethod.GET, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse list(ProtobufResponse actResponse, 
                @ApiParameterDoc("页码(从1开始)") @PathVariable Integer page, 
                @ApiParameterDoc("用于分页, 记录时间游标或主键游标") @PathVariable Long ts) throws Exception {

        Pagination<{{_tbi_.java.name}}> result = new Pagination<{{_tbi_.java.name}}>();
        result.setIndex(page);
        result.setStart(ts);

        //TODO: service function
        UserIdentity user = getCurrentUser();

        for({{_tbi_.java.name}} item : result.getItems()) {
            //convert item to PB{{_tbi_.java.name}}
            PB{{_tbi_.java.name}} msg = {{_tbi_.java.name}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        }
        actResponse.getBuilder().setTotal(result.getTotal());
        return actResponse.build();
    }

    /**
     * @param actResponse 默认参数. {@link ProtobufResponse}
     * @return 返回实体 {@link PB{{_tbi_.java.name}}}
     * @throws Exception 这里抛出无法预测的异常. 业务异常都要处理，把异常的业务代号发回移动端
     */
    @ApiMethodDoc(value = "读取{{ _tbi_.java.name }}详情", returnClass = PB{{_tbi_.java.name}}.class)
    @RequestMapping(value="{id}", method=RequestMethod.GET, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse view(ProtobufResponse actResponse, 
                @ApiParameterDoc("记录主键id") @PathVariable {{_tbi_.pk.java.typeName}} id) throws Exception {

        UserIdentity user = getCurrentUser();

        try {
            {{_tbi_.java.name}} item = {{_tbi_.java.varName}}Service.find(user, id);
            //convert item to PB{{_tbi_.java.name}}
            PB{{_tbi_.java.name}} msg = {{_tbi_.java.name}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        }catch (EntityNotFoundException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }

    /**
     * @param form 默认参数, 有传入的参数自动构造. {@link Mobile{{ _tbi_.java.name }}Form}
     * @param result 默认参数, 传入参数的自动校验结果. 
     * @param actResponse 默认参数 {@link ProtobufResponse}
     * @return 返回实体 {@link PB{{_tbi_.java.name}}}
     * @throws Exception 这里抛出无法预测的异常. 业务异常都要处理，把异常的业务代号发回移动端
     */
    @ApiMethodDoc(value = "新建{{ _tbi_.java.name }}记录", returnClass = PB{{_tbi_.java.name}}.class)
    @RequestMapping(method = RequestMethod.POST, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse postCreate(ProtobufResponse actResponse,
                @ApiParameterDoc("由传入的参数自动构造, 并做校验") @Valid Mobile{{_tbi_.java.name}}Form form, BindingResult result
                ) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse.build();
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.java.name}} item = form.to();

        try{
            item = {{_tbi_.java.varName}}Service.create(user, item);
            PB{{_tbi_.java.name}} msg = {{_tbi_.java.name}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        } catch (ServiceException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }

    /**
     * @param form 默认参数, 由传入的参数自动构造. {@link Mobile{{ _tbi_.java.name }}Form}
     * @param result 默认参数, 传入参数的自动校验结果. 
     * @param id 记录主键, {{_tbi_.pk.java.typeName}}
     * @param actResponse 默认参数 {@link ProtobufResponse}
     * @return 返回实体 {@link PB{{_tbi_.java.name}}}
     * @throws Exception 这里抛出无法预测的异常. 业务异常都要处理，把异常的业务代号发回移动端
     */
    @ApiMethodDoc(value = "修改{{ _tbi_.java.name }}记录", returnClass = PB{{_tbi_.java.name}}.class)
    @RequestMapping(value="{id}", method = RequestMethod.PUT, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse postSave(
                ProtobufResponse actResponse,
                @ApiParameterDoc("由传入的参数自动构造, 并做校验") @Valid Mobile{{_tbi_.java.name}}Form form, BindingResult result, 
                @ApiParameterDoc("记录主键") @PathVariable {{_tbi_.pk.java.typeName}} id
                ) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse.build();
        }

        UserIdentity user = getCurrentUser();

        {{_tbi_.java.name}} item = form.to();
        item.setId(id);

        try{
            item = {{_tbi_.java.varName}}Service.save(user, item);
            PB{{_tbi_.java.name}} msg = {{_tbi_.java.name}}Convertor.toPB(item);
            actResponse.getBuilder().addData(msg.toByteString());
        } catch (ServiceException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }
        
        return actResponse.build();
    }

    /**
     * @param id 记录主键, {{_tbi_.pk.java.typeName}}
     * @param actResponse 默认参数. {@link ProtobufResponse} 
     * @return 返回{@link PAppResponse}. 
     * @throws Exception 这里抛出无法预测的异常. 业务异常都要处理，把异常的业务代号发回移动端
     */
    @ApiMethodDoc(value = "删除{{ _tbi_.java.name }}记录", returnClass = PAppResponse.class)
    @RequestMapping(value="{id}", method = RequestMethod.DELETE, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse postRemove(ProtobufResponse actResponse,
                @ApiParameterDoc("记录主键") @PathVariable {{_tbi_.pk.java.typeName}} id
                ) throws Exception {

        UserIdentity user = getCurrentUser();

        try{
            {{_tbi_.java.varName}}Service.removeBy(user, id);
        } catch (ServiceException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getErrorCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }
    
}