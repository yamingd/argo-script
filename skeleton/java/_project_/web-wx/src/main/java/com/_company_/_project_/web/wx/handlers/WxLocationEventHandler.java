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
public class WxLocationEventHandler extends AbstractWxHandler<WxEvent> {

    @Override
    public String getMsgType() {
        return WxMessageTypeEnum.Event + ":" + WxEventEnum.Location;
    }

    /*
    WxEvent{WxMessage{rootElement=[Element: <xml/>], document=[Document:  No DOCTYPE declaration, Root is [Element: <xml/>]], msgId='null', toUserName='gh_97079a067881', fromUserName='oyer6jnK50Th_hC_JiS1lqTm1Fbk', createTime=1425280757, msgType='event'}, event='CLICK', eventKey='latest', ticket='null'}
     */

    @Override
    public WxResponse execute(WxEvent message) {
        WxResponse response = null;
        //do something
        if (response != null){
            response.wrapSessionInfo(message);
        }
        return response;
    }

}
