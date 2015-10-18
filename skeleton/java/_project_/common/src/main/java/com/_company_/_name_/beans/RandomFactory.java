package com._company_._project_.beans;

import com.argo.redis.RedisBuket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Random;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Created by yamingd on 9/2/15.
 */
@Component
public class RandomFactory {

    public static final String RND_CACHE_KEY = "rnd:%s:%s";

    public static final String bets = "123456789abcdefghijklmnpqrstuvwxyzABCDEFGHIJKLMNPQRSTUVWXYZ";

    private boolean test = false;

    private AtomicLong source = new AtomicLong();

    private Random random = new Random(System.currentTimeMillis());

    @Autowired(required = false)
    RedisBuket redisBuket;

    public void setTest(boolean test) {
        this.test = test;
    }

    private long incr(String key){
        if (null == redisBuket){
            return source.incrementAndGet();
        }else {
            return redisBuket.incr(key, 1);
        }
    }

    /**
     *
     * @param max
     * @return int
     */
    public int any(int max){
        return random.nextInt(max);
    }

    /**
     *
     * @param count
     * @return String
     */
    public String anyString(int count){
        char[] ret = new char[count];
        for (int i = 0; i < count; i++) {
            int index = random.nextInt(bets.length());
            ret[i] = bets.charAt(index);
        }
        return new String(ret);
    }

    /**
     *
     * @param type
     * @param pkId
     * @return long
     */
    public long seq(Class<?> type, long pkId){
        String key = String.format(RND_CACHE_KEY, type.getName(), pkId);
        long seq = incr(key);
        int px = base(seq);
        long ret = pkId * (long)Math.pow(10, px) + seq;
        return ret;
    }

    private int base(long num) {
        int px = 4;
        if (num > 99999999){
            px = 9;
        } else if (num > 9999999){
            px = 8;
        }else if (num > 999999){
            px = 7;
        }else if (num > 99999){
            px = 6;
        }else if (num > 9999){
            px = 5;
        }

        System.out.print("num: " + num + "\t" + px + "\t");
        return px;
    }

    public static void main(String[] args){
        RandomFactory factory = new RandomFactory();
        factory.setTest(true);
        System.out.println(factory.anyString(6));
        System.out.println(factory.seq(Integer.class, 3));
    }
}
