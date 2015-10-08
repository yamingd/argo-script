package com._company_._project_;

import java.util.Date;

/**
 * Created by _user_.
 */
public class EpochTime {

    // 2015-1-1
    public static long epoch = 1420041600L;
    /**
     * 返回日期
     * @param ts
     * @return
     */
    public static Date create(int ts){
        long ts0 = ts + epoch;
        return new Date(ts0 * 1000);
    }

    public static Date create(long ts){
        long ts0 = ts + epoch;
        return new Date(ts0 * 1000);
    }

    public static long nowInMs(){
        return System.currentTimeMillis() - epoch * 1000;
    }

    /**
     * 返回时间戳
     * @param date
     * @return
     */
    public static Long create(Date date){
        return date.getTime()/1000 - epoch;
    }

    public static Long now(){
        return System.currentTimeMillis() / 1000 - epoch;
    }

    public static void main(String[] args){
        System.out.println(now());
    }
}
