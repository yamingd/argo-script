package com.kcompany.kproject;

import android.support.v4.util.ArrayMap;

import java.util.Map;

/**
 * Created by user on 6/19/15.
 */
public final class UserKinds {

    public static final int kTeacher = 1;
    public static final String sTeacher = "teacher";

    public static final int kParent = 2;
    public static final String sParent = "parent";

    public static final int kStudent = 3;
    public static final String sStudent = "student";

    public static final int kFemale = 2;
    public static final int kMale = 1;

    public static final Map<Integer, String> kindMap;

    static {
        kindMap = new ArrayMap<Integer, String>();
        kindMap.put(kTeacher, sTeacher);
        kindMap.put(kParent, sParent);
        kindMap.put(kStudent, sStudent);
    }
}
