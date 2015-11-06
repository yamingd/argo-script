package com.{{prj._company_}}.{{prj._name_}}.service.{{_tbi_.package}};

import com.argo.sdk.ApiError;
import com.argo.sdk.AppSession;
import com.argo.sdk.http.APICallback;
import com.argo.sdk.http.APIClientProvider;
import com.argo.sdk.http.PBuilder;
import com.argo.sdk.protobuf.PAppResponse;
import com.argo.sqlite.SqliteBlock;
import net.sqlcipher.database.SQLiteDatabase;

import com.{{prj._company_}}.{{prj._name_}}.service.PBServiceBaseImpl;

import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.package}}.{{_tbi_.pb.name}}ListResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.package}}.{{_tbi_.pb.name}}CreateResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.package}}.{{_tbi_.pb.name}}SaveResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.package}}.{{_tbi_.pb.name}}RemoveResultEvent;
import com.{{prj._company_}}.{{prj._name_}}.event.{{_tbi_.package}}.{{_tbi_.pb.name}}DetailResultEvent;

import com.{{prj._company_}}.{{prj._name_}}.protobuf.{{_tbi_.package}}.{{_tbi_.pb.name}};
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_tbi_.package}}.{{_tbi_.pb.name}}Mapper;

import com.squareup.okhttp.Request;
import com.squareup.otto.Bus;

import java.util.List;

import javax.inject.Inject;

import timber.log.Timber;

/**
 * Created by {{_user_}} on {{_now_}}.
 */
public class {{_tbi_.pb.name}}ServiceImpl extends PBServiceBaseImpl implements {{_tbi_.pb.name}}Service {


    @Inject
    public {{_tbi_.pb.name}}ServiceImpl(APIClientProvider apiClientProvider, AppSession appSession, Bus eventBus) {
        super(apiClientProvider, appSession, eventBus);
    }

    @Override
    public void findLatest(int cursorId) {
        List<{{_tbi_.pb.name}}> list = {{_tbi_.pb.name}}Mapper.instance.selectLimit("{{_tbi_.pk.pb.name}} > ?", "{{_tbi_.pk.pb.name}} desc", new String[]{cursorId+"", PAGE_SIZE + "", "0"});
        if (list.size() > 0){
            {{_tbi_.pb.name}}ListResultEvent event = new {{_tbi_.pb.name}}ListResultEvent(list, 1);
            event.setDataFromCache(true);
            eventBus.post(event);
        }

        final String url = String.format("/m/{{_tbi_.mvc_url()}}/1/%d", cursorId);
        apiClientProvider.asyncGet(url, null, new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(error));
                    return;
                }

                try {
                    final List<{{_tbi_.pb.name}}> result = apiClientProvider.parseProtobufResponse(response, {{_tbi_.pb.name}}.class);
                    if (result.size() == 0){
                        eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(result, 1));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            {{_tbi_.pb.name}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(result, 1));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, {{_tbi_.pb.name}}.class);
                    eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(e));
                }
            }
        });
    }

    @Override
    public void findMore(int page, int cursorId) {
        List<{{_tbi_.pb.name}}> list = {{_tbi_.pb.name}}Mapper.instance.selectLimit("{{_tbi_.pk.pb.name}} < ?", "{{_tbi_.pk.pb.name}} desc", new String[]{cursorId+"", PAGE_SIZE + "", "0"});
        if (list.size() > 0){
            {{_tbi_.pb.name}}ListResultEvent event = new {{_tbi_.pb.name}}ListResultEvent(list, 1);
            event.setDataFromCache(true);
            eventBus.post(event);
            if(list.size() == PAGE_SIZE){
                return;
            }
        }

        final String url = String.format("/m/{{_tbi_.mvc_url()}}/%d/%d", page, cursorId);
        apiClientProvider.asyncGet(url, null, new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(error));
                    return;
                }

                try {
                    final List<{{_tbi_.pb.name}}> result = apiClientProvider.parseProtobufResponse(response, {{_tbi_.pb.name}}.class);
                    if (result.size() == 0){
                        eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(result, 1));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            {{_tbi_.pb.name}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(result, 1));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, {{_tbi_.pb.name}}.class);
                    eventBus.post(new {{_tbi_.pb.name}}ListResultEvent(e));
                }
            }
        });
    }

    @Override
    public void findBy({{_tbi_.pk.valType}} itemId, boolean withRef) {
        {{_tbi_.pb.name}} item = null;
        if (withRef){
            item = {{_tbi_.pb.name}}Mapper.instance.getWithRef(itemId);
        }else{
            item = {{_tbi_.pb.name}}Mapper.instance.get(itemId);
        }

        this.loadBy(itemId);

    }

    @Override
    public void loadBy({{_tbi_.pk.valType}} itemId) {
        final String url = String.format("/m/{{_tbi_.mvc_url()}}/%d", itemId);
        apiClientProvider.asyncGet(url, null, new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new {{_tbi_.pb.name}}DetailResultEvent(error));
                    return;
                }

                try {
                    final List<{{_tbi_.pb.name}}> result = apiClientProvider.parseProtobufResponse(response, {{_tbi_.pb.name}}.class);
                    if (result.size() == 0){
                        eventBus.post(new {{_tbi_.pb.name}}DetailResultEvent(NO_RESULT_RETURN));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            {{_tbi_.pb.name}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new {{_tbi_.pb.name}}DetailResultEvent(result.get(0)));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, {{_tbi_.pb.name}}.class);
                    eventBus.post(new {{_tbi_.pb.name}}DetailResultEvent(e));
                }
            }
        });
    }

    @Override
    public void create({{_tbi_.pb.name}} item) {
        final String url = "/m/{{_tbi_.mvc_url()}}/";
        PBuilder builder = PBuilder.i();
        //构造Http参数
        apiClientProvider.asyncPOST(url, builder.vs(), new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error){
                    error.printout();
                    eventBus.post(new {{_tbi_.pb.name}}CreateResultEvent(error));
                    return;
                }

                try {
                    final List<{{_tbi_.pb.name}}> result = apiClientProvider.parseProtobufResponse(response, {{_tbi_.pb.name}}.class);
                    if (result.size() == 0){
                        eventBus.post(new {{_tbi_.pb.name}}CreateResultEvent(NO_RESULT_RETURN));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            {{_tbi_.pb.name}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new {{_tbi_.pb.name}}CreateResultEvent(result.get(0)));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, {{_tbi_.pb.name}}.class);
                    eventBus.post(new {{_tbi_.pb.name}}CreateResultEvent(e));
                }
            }
        });
    }

    @Override
    public void save({{_tbi_.pb.name}} item) {
        final String url = String.format("/m/{{_tbi_.mvc_url()}}/%d", item.get{{_tbi_.pk.java.getterName}}());
        PBuilder builder = PBuilder.i();
        //构造Http参数
        apiClientProvider.asyncPUT(url, builder.vs(), new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error) {
                    error.printout();
                    eventBus.post(new {{_tbi_.pb.name}}SaveResultEvent(error));
                    return;
                }

                try {
                    final List<{{_tbi_.pb.name}}> result = apiClientProvider.parseProtobufResponse(response, {{_tbi_.pb.name}}.class);
                    if (result.size() == 0) {
                        eventBus.post(new {{_tbi_.pb.name}}SaveResultEvent(NO_RESULT_RETURN));
                        return;
                    }

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            {{_tbi_.pb.name}}Mapper.instance.saveWithRef(result);
                        }
                    });

                    eventBus.post(new {{_tbi_.pb.name}}SaveResultEvent(result.get(0)));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, {{_tbi_.pb.name}}.class);
                    eventBus.post(new {{_tbi_.pb.name}}SaveResultEvent(e));
                }
            }
        });
    }

    @Override
    public void remove(final {{_tbi_.pb.name}} item) {
        final String url = String.format("/m/{{_tbi_.mvc_url()}}/%d", item.get{{_tbi_.pk.java.getterName}}());
        PBuilder builder = PBuilder.i();
        //构造Http参数
        apiClientProvider.asyncDelete(url, builder.vs(), new APICallback() {
            @Override
            public void onResponse(PAppResponse response, Request request, ApiError error) {
                if (null != error) {
                    error.printout();
                    eventBus.post(new {{_tbi_.pb.name}}RemoveResultEvent(error));
                    return;
                }

                try {

                    dbUser.get().update(new SqliteBlock<SQLiteDatabase>() {
                        @Override
                        public void execute(SQLiteDatabase engine) {
                            {{_tbi_.pb.name}}Mapper.instance.delete(item);
                        }
                    });

                    eventBus.post(new {{_tbi_.pb.name}}RemoveResultEvent(item));

                } catch (Exception e) {
                    Timber.e(e, "parse Error, %s(%s)", url, {{_tbi_.pb.name}}.class);
                    eventBus.post(new {{_tbi_.pb.name}}RemoveResultEvent(e));
                }
            }
        });
    }
}
