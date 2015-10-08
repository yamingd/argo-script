package com._company_._project_.web.wx.handlers;

import com.argo.wx.handler.AbstractWxHandler;
import com.argo.wx.message.WxEvent;
import com.argo.wx.message.WxEventEnum;
import com.argo.wx.message.WxMessageTypeEnum;
import com.argo.wx.response.WxResponse;
import org.springframework.stereotype.Component;

/**
 * Created by Yaming on 2014/12/18.
 */
@Component
public class WxUnsubscribeEventHandler extends AbstractWxHandler<WxEvent> {

    @Override
    public String getMsgType() {
        return WxMessageTypeEnum.Event + ":" + WxEventEnum.Unsubscribe;
    }

    @Override
    public WxResponse execute(WxEvent message) {
        String openId = message.getFromUserName();

        //do something with openId

        return null;
    }

}
