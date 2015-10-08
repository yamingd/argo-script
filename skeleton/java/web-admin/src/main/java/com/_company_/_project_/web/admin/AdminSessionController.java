package com._company_._project_.web.admin;

import com.argo.security.UserIdentity;
import com.argo.security.exception.PasswordInvalidException;
import com.argo.security.exception.UnauthorizedException;
import com.argo.security.service.AuthorizationService;
import com.argo.web.JsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

/**
 * Created by yamingd on 9/8/15.
 */
@Controller
@RequestMapping("/a/sessions")
public class AdminSessionController extends AdminBaseController {

    @Autowired
    private AuthorizationService<UserIdentity> authorizationService;

    @RequestMapping(value="/", method = RequestMethod.POST, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse login(@Valid AdminSessionForm form, BindingResult result,
                              JsonResponse actResponse,
                              HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (result.hasErrors()){
            this.wrapError(result, actResponse);
            return actResponse;
        }

        UserIdentity user = null;

        try{

            user = authorizationService.verifyUserPassword(form.getUserName(), form.getPassword());
            this.rememberUser(request, response, user.getIdentityId());

        } catch (PasswordInvalidException e) {
            logger.error(e.getMessage(), e);
            actResponse.setCode(e.getStatusCode());
        }

        return actResponse;
    }


    @RequestMapping(value="{id}", method = RequestMethod.DELETE, produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public JsonResponse signout(@PathVariable Long id,
                                JsonResponse actResponse,
                                HttpServletRequest request, HttpServletResponse response) throws Exception {

        try{

            UserIdentity user = getCurrentUser();
            this.clearUser(request, response);

        } catch (UnauthorizedException e) {

        }

        return actResponse;
    }
}
