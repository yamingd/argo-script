package com._company_._project_.service.impl;

import com.argo.security.UserIdentity;
import com.argo.security.exception.PasswordInvalidException;
import com.argo.security.exception.PermissionDeniedException;
import com.argo.security.exception.UnauthorizedException;
import com.argo.security.service.AuthorizationService;
import org.springframework.stereotype.Service;

/**
 * Created by _user_.
 */
@Service
public class AuthorizationServiceImpl implements AuthorizationService {

    @Override
    public UserIdentity verifyCookie(String uid) throws UnauthorizedException {
        return null;
    }

    @Override
    public UserIdentity verifyUserPassword(String userName, String password) throws PasswordInvalidException {
        return null;
    }

    @Override
    public UserIdentity verifyUserPassword(UserIdentity user, String password) throws PasswordInvalidException {
        return null;
    }

    @Override
    public void verifyAccess(String url) throws PermissionDeniedException {

    }
}
