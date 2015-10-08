package com.kcompany.kproject.service;

import com.kcompany.kproject.SqliteCommonProvider;
import com.kcompany.kproject.SqliteUserProvider;
import com.kcompany.kproject.model.NoResultException;
import com.argo.sdk.AppSession;
import com.argo.sdk.FlashBucket;
import com.argo.sdk.http.APIClientProvider;
import com.squareup.otto.Bus;

import javax.inject.Inject;

/**
 * Created by user on 6/18/15.
 */
public class TSServiceBase implements TSService {

    public static final int PAGE_SIZE = 20;

    protected APIClientProvider apiClientProvider;

    protected AppSession appSession;

    protected Bus eventBus;

    @Inject
    protected SqliteUserProvider dbUser;

    @Inject
    protected SqliteCommonProvider dbCommon;

    @Inject
    protected FlashBucket flashBucket;

    protected static Exception NO_RESULT_RETURN = new NoResultException();

    @Inject
    public TSServiceBase(APIClientProvider apiClientProvider, AppSession appSession, Bus eventBus) {
        this.apiClientProvider = apiClientProvider;
        this.appSession = appSession;
        this.eventBus = eventBus;

        this.setupEventSubscriber();
    }

    /**
     * 事件订阅
     */
    @Override
    public void setupEventSubscriber(){

    }

    /**
     * 取消订阅
     */
    @Override
    public void removeEventSubscriber(){

    }
}
