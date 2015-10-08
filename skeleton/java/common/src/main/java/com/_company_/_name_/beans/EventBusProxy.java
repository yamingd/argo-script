package com._company_._project_.beans;

import com.argo.skeleton.ObjectEvent;
import com.google.common.eventbus.DeadEvent;
import com.google.common.eventbus.EventBus;
import com.google.common.eventbus.Subscribe;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.stereotype.Component;

/**
 * Created by yamingd on 9/8/15.
 */
@Component
public class EventBusProxy implements InitializingBean {

    protected Logger logger = LoggerFactory.getLogger(this.getClass());

    private EventBus eventBus;

    public static final String Identifier = "app";

    @Override
    public void afterPropertiesSet() throws Exception {
        eventBus = new EventBus(Identifier);
        eventBus.register(this);
    }

    public void register(Object object){
        eventBus.register(object);
    }

    public void unregister(Object object){
        eventBus.unregister(object);
    }

    /**
     * 发布事件
     * @param identifier
     * @param event
     */
    public void post(String identifier, ObjectEvent event){

        eventBus.post(event);

    }

    @Subscribe
    public void onDeadEvent(DeadEvent deadEvent){
        logger.error("DeadEvent. {}, source: {}", deadEvent.getEvent(), deadEvent.getSource());
    }

}
