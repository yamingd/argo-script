package com._company_._project_.web.mobile;

import com.argo.security.UserIdentity;
import com.argo.security.exception.PasswordInvalidException;
import com.argo.security.exception.UnauthorizedException;
import com.argo.security.service.AuthorizationService;
import com.argo.web.Enums;
import com.argo.web.protobuf.PAppResponse;
import com.argo.web.protobuf.ProtobufResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;

/**
 * Created by yamingd on 9/8/15.
 */
@Controller
@RequestMapping("/m/sessions")
public class MobileSessionController extends MobileBaseController {

    @Autowired
    private AuthorizationService<UserIdentity> authorizationService;

    @RequestMapping(value="/", method = RequestMethod.POST, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse login(@Valid MobileSessionForm form, BindingResult result,
                                   ProtobufResponse actResponse) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse.build();
        }

        UserIdentity user = null;

        try{

            user = authorizationService.verifyUserPassword(form.getUserName(), form.getPassword());

            // TODO: turn user into PAppResponse
            // actResponse.getBuilder().addData(msg.toByteString());
        } catch (PasswordInvalidException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getStatusCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }

    @RequestMapping(value="{id}", method = RequestMethod.PUT, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse autologin(@PathVariable Long id,
                              ProtobufResponse actResponse) throws Exception {

        try{

            UserIdentity user = getCurrentUser();

            // TODO: turn user into PAppResponse
            // actResponse.getBuilder().addData(msg.toByteString());

        } catch (UnauthorizedException e) {
            logger.error(e.getMessage(), e);
            actResponse.getBuilder().setCode(e.getStatusCode()).setMsg(e.getMessage());
        }

        return actResponse.build();
    }

    @RequestMapping(value="{id}", method = RequestMethod.DELETE, produces = Enums.PROTOBUF_VALUE)
    @ResponseBody
    public PAppResponse signout(@PathVariable Long id,
                                  ProtobufResponse actResponse) throws Exception {

        try{

            UserIdentity user = getCurrentUser();
            //TODO:

        } catch (UnauthorizedException e) {

        }

        return actResponse.build();
    }
}
