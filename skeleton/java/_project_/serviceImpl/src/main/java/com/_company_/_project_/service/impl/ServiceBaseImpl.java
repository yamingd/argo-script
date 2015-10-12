package com._company_._project_.service.impl;

import com._company_._project_.beans.EventBusProxy;
import com.argo.redis.RedisBuket;
import com.argo.service.common.AsyncTaskPool;
import com._company_._project_.service.ServiceBase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.Assert;

import java.util.List;
import java.io.Serializable;

/**
 * Created by _user_.
 */
public abstract class ServiceBaseImpl<T extends Serializable, PK extends Comparable>
        implements InitializingBean, DisposableBean {

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    protected RedisBuket redisBuket;

    @Autowired
    protected AsyncTaskPool asyncTaskPool;

    @Autowired
    protected EventBusProxy eventBusProxy;

    @Override
    public void afterPropertiesSet() throws Exception {
        Assert.notNull(redisBuket);
        Assert.notNull(asyncTaskPool);
        //TODO: load configuration
    }

    @Override
    public void destroy() throws Exception {

    }

}
