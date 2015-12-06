package com._company_._project_;

import java.util.Date;

/**
 * Created by _user_.
 */
public class ConvertorBase {

    public static Integer dateToInt(Date date){
        if (date == null){
            return null;
        }

        return (int)(date.getTime() / 1000);
    }

}
