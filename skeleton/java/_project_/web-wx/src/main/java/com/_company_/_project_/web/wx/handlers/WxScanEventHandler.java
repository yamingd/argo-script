package com._company_._project_.web.wx.handlers;

import com.argo.security.UserIdentity;
import com.argo.web.WebConfig;
import com.argo.wx.handler.AbstractWxHandler;
import com.argo.wx.message.WxEvent;
import com.argo.wx.message.WxEventEnum;
import com.argo.wx.message.WxMessageTypeEnum;
import com.argo.wx.response.WxResponse;
import com.argo.wx.response.WxTextResponse;
import org.springframework.stereotype.Component;

/**
 * Created by Yaming on 2014/12/18.
 */
@Component
public class WxScanEventHandler extends AbstractWxHandler<WxEvent> {

    @Override
    public String getMsgType() {
        return WxMessageTypeEnum.Event + ":" + WxEventEnum.Scan;
    }

    @Override
    public WxResponse execute(WxEvent message) {
        String openId = message.getFromUserName();

        // do something with openId

        UserIdentity user = null;

        String msg;
        if (user == null){
            msg = String.format(WxContentMessage.Welcome0, WebConfig.instance.getTitle());
        }else{
            msg = String.format(WxContentMessage.Welcome1, "Your name");
        }

        WxTextResponse response = new WxTextResponse(msg);
        return response;
    }

}
