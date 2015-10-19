package com._company_._project_.web.mobile;

import com._company_._project_.Devices;
import com.argo.redis.RedisBuket;
import com.argo.security.RequestCipher;
import com.argo.security.SessionCookieHolder;
import com.argo.security.exception.*;
import com.argo.service.common.AsyncTaskPool;
import com.argo.web.MvcController;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by yamingd on 9/8/15.
 */
@Controller
@RequestMapping("/m/")
public class MobileBaseController extends MvcController {

    public static final String X_CID = "X-cid";
    public static final String X_SIGN = "X-sign";
    public static final String PROTOBUF_ENCRYPT = "protobuf-encrypt";

    @Autowired
    protected AsyncTaskPool asyncTaskPool;

    @Autowired
    protected RedisBuket redisBuket;


    public boolean needLogin() {
        return true;
    }


    @Override
    public void init() throws Exception {
        RequestAttributes ra = RequestContextHolder.getRequestAttributes();
        HttpServletRequest request = ((ServletRequestAttributes) ra).getRequest();

        if (needSecurity(request)) {
            request.setAttribute(PROTOBUF_ENCRYPT, 16);
        }

        if (this.needLogin()) {
            this.checkKickOff(request);
        }

        checkRequestSecurity(request);

    }

    private void checkKickOff(HttpServletRequest request) throws UserKickedOffException {
        UserKickedOffException ex = new UserKickedOffException("You have been kicked off.");

        String deviceId = request.getHeader(X_CID);

        String currentUid = null;
        try {
            currentUid = SessionCookieHolder.getCurrentUID(request);
        } catch (UnauthorizedException e) {
            throw ex;
        } catch (CookieExpiredException e) {
            throw ex;
        } catch (CookieInvalidException e) {
            throw ex;
        }

        if (null != currentUid) {
            Long uid = Long.parseLong(currentUid);
            if (uid > 0) {
                //TODO:
                boolean kickOff = false;
                if (kickOff){
                    throw ex;
                }
            }
        }
    }

    private boolean needSecurity(HttpServletRequest request){
        String userAgent = getUA(request);
        String clientVer = request.getHeader("X-ver");

        if (clientVer == null){
            return false;
        }

        return true;
    }

    protected String getUA(HttpServletRequest request) {
        return request.getHeader("User-Agent");
    }

    /**
     *
     * @param request
     * @return
     */
    protected int getRequestSource(HttpServletRequest request){
        return Devices.get(getUA(request));
    }

    protected void checkRequestSecurity(HttpServletRequest request) throws PermissionDeniedException {
        String userAgent = getUA(request);
        String clientVer = request.getHeader("X-ver");
        String xsign = request.getHeader(X_SIGN);

        logger.debug("checkRequestSecurity: {}, {}, {}", userAgent, clientVer, xsign);

        boolean needSecurity = needSecurity(request);

        if (!needSecurity){
            return;
        }

        PermissionDeniedException permissionDeniedException = new PermissionDeniedException(request.getPathInfo());

        if (StringUtils.isBlank(xsign)){
            if (needSecurity){
                logger.error("PermissionDeniedException, {}", request);
                throw permissionDeniedException;
            }
            return;
        }

        if (xsign.length() < 64){
            logger.error("PermissionDeniedException, {}", request);
            throw permissionDeniedException;
        }

        String key = xsign.substring(0, 10);
        String cacheKey = "nonce:" + key;
        long flag = redisBuket.setnx(cacheKey, "0");
        if (flag == 0){
            logger.error("PermissionDeniedException, {}", request);
            throw permissionDeniedException;
        }
        redisBuket.expire(cacheKey, 86400 * 3);

        String currentUid = null;
        try {
            currentUid = SessionCookieHolder.getCurrentUID(request);
        } catch (UnauthorizedException e) {
            throw permissionDeniedException;
        } catch (CookieInvalidException e) {
            throw permissionDeniedException;
        } catch (CookieExpiredException e) {
            throw permissionDeniedException;
        }

        if (currentUid == null){
            throw new PermissionDeniedException(request.getPathInfo());
        }

        String url = request.getRequestURI();
        RequestCipher.verify(url, currentUid, xsign);
    }
    

}
