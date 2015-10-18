package com._company_._project_.common;

import com.argo.security.AESProvider;

/**
 * Created by _user_.
 */
public final class AESHelper {
    /**
     * iOS, Android, C++, Java 保持一致
     */
    private static final AESProvider aesProvider = new AESProvider();

    /**
     * 加密
     *
     * @param content 需要加密的内容
     * @return String
     */
    public static String encrypt(String content) {
        return aesProvider.encrypt(content);
    }

    /**解密
     * @param content  待解密内容
     * @return String
     */
    public static String decrypt(String content) {
        return aesProvider.decrypt(content);
    }

}
