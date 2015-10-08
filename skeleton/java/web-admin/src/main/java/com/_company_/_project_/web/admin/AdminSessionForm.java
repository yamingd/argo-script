package com._company_._project_.web.admin;

import org.hibernate.validator.constraints.NotBlank;
import org.springframework.context.annotation.Scope;

/**
 * Created by yamingd on 9/30/15.
 */
@Scope("prototype")
public class AdminSessionForm {

    @NotBlank(message = "userName_blank")
    private String userName;

    @NotBlank(message = "userName_blank")
    private String password;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
