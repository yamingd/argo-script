package com._company_._project_.web.wx.handlers;

import com.argo.wx.handler.AbstractWxHandler;
import com.argo.wx.message.WxMessageTypeEnum;
import com.argo.wx.message.WxTextMessage;
import com.argo.wx.response.WxResponse;
import com.argo.wx.response.WxTextResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

/**
 * Created by user on 3/17/15.
 */
@Component
public class WxTextMessageHandler extends AbstractWxHandler<WxTextMessage> {

    private static final String help = "你好";

    @Override
    public String getMsgType() {
        return WxMessageTypeEnum.Text;
    }

    @Override
    public WxResponse execute(WxTextMessage message) {
        logger.info("{}", message.getContent());
        String ct = message.getContent();
        String retMsg = "";
        if (StringUtils.isNotBlank(ct)){
            if ("?".equalsIgnoreCase(ct)){
                retMsg = help;
            }else{
                retMsg = help;
            }
        }

        WxTextResponse response = new WxTextResponse(retMsg);
        //response.wrapSessionInfo(message);
        return response;
    }
}
