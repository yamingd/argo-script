package com.{{prj._company_}}.{{prj._name_}}.service.{{_tbi_.package}};

import com.{{prj._company_}}.{{prj._name_}}.protobuf.{{_tbi_.package}}.{{_tbi_.pb.name}};
import com.{{prj._company_}}.{{prj._name_}}.mapper.{{_tbi_.package}}.{{_tbi_.pb.name}}Mapper;
import com.{{prj._company_}}.{{prj._name_}}.service.PBServiceBase;

import java.util.List;

/**
 * {{_tbi_.pb.name}} API 服务
 * Created by {{_user_}}.
 */
public interface {{_tbi_.pb.name}}Service extends PBServiceBase {
	
	/**
     * 读取最新, 抛出事件 {{_tbi_.pb.name}}ListResultEvent
     * @param cursorId 时间戳
     */
    void findLatest(int cursorId);

    /**
     * 读取更多，抛出事件 {{_tbi_.pb.name}}ListResultEvent
     * @param page 页码
     * @param cursorId 时间戳
     */
    void findMore(int page, int cursorId);

    /**
     * 读取详细. 抛出事件 {{_tbi_.pb.name}}DetailResultEvent
     * @param itemId 记录主键
     * @param withRef 是否返回相关联的对象
     */
    void findBy({{_tbi_.pk.valType}} itemId, boolean withRef);

    /**
     * 从服务器加载详细. 抛出事件 {{_tbi_.pb.name}}DetailResultEvent
     * @param itemId 记录主键
     */
    void loadBy({{_tbi_.pk.valType}} itemId);

    /**
     * 新建记录. 抛出事件 {{_tbi_.pb.name}}CreateResultEvent
     * @param item 记录
     */
    void create({{_tbi_.pb.name}} item);

    /**
     * 保存修改记录. 抛出事件 {{_tbi_.pb.name}}SaveResultEvent
     * @param item 记录
     */
    void save({{_tbi_.pb.name}} item);

    /**
     * 删除记录. 抛出事件 {{_tbi_.pb.name}}RemoveResultEvent
     * @param item 记录
     */
    void remove({{_tbi_.pb.name}} item);

}