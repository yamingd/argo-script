package com.{{prj._company_}}.{{prj._name_}}.mapper.{{_module_}};

import org.springframework.transaction.annotation.Transactional;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Transactional(value="{{_module_}}Tx", rollbackFor=Exception.class)
public @interface {{_tbi_.java.name}}Tx {
}
