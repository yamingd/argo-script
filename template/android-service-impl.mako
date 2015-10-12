package com.{{prj._company_}}.{{prj._name_}}.service.{{_tbi_.mname}};

import com.argo.sdk.ApiError;
import com.argo.sdk.AppSession;
import com.argo.sdk.http.APICallback;
import com.argo.sdk.http.APIClientProvider;
import com.argo.sdk.http.PBuilder;
import com.argo.sdk.protobuf.PAppResponse;
import com.argo.sqlite.SqliteBlock;
import net.sqlcipher.database.SQLiteDatabase;

import com.{{prj._company_}}.{{prj._name_}}.service.PBServiceBaseImpl;

import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.mname}}.PB{{_tbi_.entityName}}ListResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.mname}}.PB{{_tbi_.entityName}}CreateResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.mname}}.PB{{_tbi_.entityName}}SaveResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.mname}}.PB{{_tbi_.entityName}}RemoveResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.mname}}.PB{{_tbi_.entityName}}DetailResultEvent;

import com.{{prj._company_}}.{{prj._name_}}.protobuf.{{_tbi_.mname}}.PB{{_tbi_.entityName}};
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_tbi_.mname}}.PB{{_tbi_.entityName}}Mapper;

import com.squareup.okhttp.Request;
import com.squareup.otto.Bus;

import java.util.List;

import javax.inject.Inject;

import timber.log.Timber;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
public class PB{{_tbi_.entityName}}ServiceImpl extends PBServiceBaseImpl implements PB{{_tbi_.entityName}}Service {


    @Inject
    public PB{{_tbi_.entityName}}ServiceImpl(APIClientProvider apiClientProvider, AppSession appSession, Bus eventBus) {
        super(apiClientProvider, appSession, eventBus);
    }

    @Override
    public void findLatest(int cursorId) {
        List<PB{{_tbi_.entityName}}> list = PB{{_tbi_.entityName}}Mapper.instance.selectLimit("{{_tbi_.pkCol.name}} > ?", "{{_tbi_.pkCol.name}} desc", new String[]{cursorId+"", PAGE_SIZE + "", "0"});
        if (list.size() > 0){
            PB{{_tbi_.entityName}}ListResultEvent event = new PB{{_tbi_.entityName}}ListResultEvent(list, 1);
            event.setDataFromCache(true);
            eventBus.post(event);
        }

        final String url = String.format("/{{_tbi_.mvc_url()}}/1/%d", cursorId);
        apiClientProvider.asyncGet(url, null, new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(error));
                    return;
                }

                try {
                    final List<PB{{_tbi_.entityName}}> result = apiClientProvider.parseProtobufResponse(response, PB{{_tbi_.entityName}}.class);
                    if (result.size() == 0){
                        eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(result, 1));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            PB{{_tbi_.entityName}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(result, 1));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, PB{{_tbi_.entityName}}.class);
                    eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(e));
                }
            }
        });
    }

    @Override
    public void findMore(int page, int cursorId) {
        List<PB{{_tbi_.entityName}}> list = PB{{_tbi_.entityName}}Mapper.instance.selectLimit("{{_tbi_.pkCol.name}} < ?", "{{_tbi_.pkCol.name}} desc", new String[]{cursorId+"", PAGE_SIZE + "", "0"});
        if (list.size() > 0){
            PB{{_tbi_.entityName}}ListResultEvent event = new PB{{_tbi_.entityName}}ListResultEvent(list, 1);
            event.setDataFromCache(true);
            eventBus.post(event);
            if(list.size() == PAGE_SIZE){
                return;
            }
        }

        final String url = String.format("/{{_tbi_.mvc_url()}}/%d/%d", page, cursorId);
        apiClientProvider.asyncGet(url, null, new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(error));
                    return;
                }

                try {
                    final List<PB{{_tbi_.entityName}}> result = apiClientProvider.parseProtobufResponse(response, PB{{_tbi_.entityName}}.class);
                    if (result.size() == 0){
                        eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(result, 1));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            PB{{_tbi_.entityName}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(result, 1));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, PB{{_tbi_.entityName}}.class);
                    eventBus.post(new PB{{_tbi_.entityName}}ListResultEvent(e));
                }
            }
        });
    }

    @Override
    public void findBy({{_tbi_.pkCol.valType}} itemId, boolean withRef) {
        PB{{_tbi_.entityName}} item = null;
        if (withRef){
            item = PB{{_tbi_.entityName}}Mapper.instance.getWithRef(itemId);
        }else{
            item = PB{{_tbi_.entityName}}Mapper.instance.get(itemId);
        }

        this.loadBy(itemId);

    }

    @Override
    public void loadBy({{_tbi_.pkCol.valType}} itemId) {
        final String url = String.format("/{{_tbi_.mvc_url()}}/%d", itemId);
        apiClientProvider.asyncGet(url, null, new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new PB{{_tbi_.entityName}}DetailResultEvent(error));
                    return;
                }

                try {
                    final List<PB{{_tbi_.entityName}}> result = apiClientProvider.parseProtobufResponse(response, PB{{_tbi_.entityName}}.class);
                    if (result.size() == 0){
                        eventBus.post(new PB{{_tbi_.entityName}}DetailResultEvent(NO_RESULT_RETURN));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            PB{{_tbi_.entityName}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new PB{{_tbi_.entityName}}DetailResultEvent(result.get(0)));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, PB{{_tbi_.entityName}}.class);
                    eventBus.post(new PB{{_tbi_.entityName}}DetailResultEvent(e));
                }
            }
        });
    }

    @Override
    public void create(PB{{_tbi_.entityName}} item) {
        final String url = "/{{_tbi_.mvc_url()}}/";
        PBuilder builder = PBuilder.i();
        //构造Http参数
        apiClientProvider.asyncPOST(url, builder.vs(), new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new PB{{_tbi_.entityName}}CreateResultEvent(error));
                    return;
                }

                try {
                    final List<PB{{_tbi_.entityName}}> result = apiClientProvider.parseProtobufResponse(response, PB{{_tbi_.entityName}}.class);
                    if (result.size() == 0){
                        eventBus.post(new PB{{_tbi_.entityName}}CreateResultEvent(NO_RESULT_RETURN));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            PB{{_tbi_.entityName}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new PB{{_tbi_.entityName}}CreateResultEvent(result.get(0)));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, PB{{_tbi_.entityName}}.class);
                    eventBus.post(new PB{{_tbi_.entityName}}CreateResultEvent(e));
                }
            }
        });
    }

    @Override
    public void save(PB{{_tbi_.entityName}} item) {
        final String url = String.format("/{{_tbi_.mvc_url()}}/%d", item.get{{_tbi_.pkCol.capName}}());
        PBuilder builder = PBuilder.i();
        //构造Http参数
        apiClientProvider.asyncPUT(url, builder.vs(), new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error) {
                    error.printout();
                    eventBus.post(new PB{{_tbi_.entityName}}SaveResultEvent(error));
                    return;
                }

                try {
                    final List<PB{{_tbi_.entityName}}> result = apiClientProvider.parseProtobufResponse(response, PB{{_tbi_.entityName}}.class);
                    if (result.size() == 0) {
                        eventBus.post(new PB{{_tbi_.entityName}}SaveResultEvent(NO_RESULT_RETURN));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            PB{{_tbi_.entityName}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new PB{{_tbi_.entityName}}SaveResultEvent(result.get(0)));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, PB{{_tbi_.entityName}}.class);
                    eventBus.post(new PB{{_tbi_.entityName}}SaveResultEvent(e));
                }
            }
        });
    }

    @Override
    public void remove(final PB{{_tbi_.entityName}} item) {
        final String url = String.format("/{{_tbi_.mvc_url()}}/%d", item.get{{_tbi_.pkCol.capName}}());
        PBuilder builder = PBuilder.i();
        //构造Http参数
        apiClientProvider.asyncDelete(url, builder.vs(), new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error) {
                    error.printout();
                    eventBus.post(new PB{{_tbi_.entityName}}RemoveResultEvent(error));
                    return;
                }

                try {

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            PB{{_tbi_.entityName}}Mapper.instance.delete(item);
                        }
                    });

                    eventBus.post(new PB{{_tbi_.entityName}}RemoveResultEvent(item));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, PB{{_tbi_.entityName}}.class);
                    eventBus.post(new PB{{_tbi_.entityName}}RemoveResultEvent(e));
                }
            }
        });
    }
}
