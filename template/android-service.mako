package com.{{_prj_.company}}.{{_prj_.name}}.service.{{_tbi_.mname}};

import com.{{_prj_.company}}.{{_prj_.name}}.protobuf.{{_tbi_.mname}}.PB{{_tbi_.entityName}};
import com.{{_prj_.company}}.{{_prj_.name}}.mapper.{{_tbi_.mname}}.PB{{_tbi_.entityName}}Mapper;
import com.{{_prj_.company}}.{{_prj_.name}}.service.PBServiceBase;

import java.util.List;

/**
 * PB{{_tbi_.entityName}} API 服务
 * Created by {{_user_}} on {{_now_}}.
 */
public interface PB{{_tbi_.entityName}}Service extends PBServiceBase {
	
	/**
     * 读取最新, 抛出事件 PB{{_tbi_.entityName}}ListResultEvent
     * @param cursorId 时间戳
     */
    void findLatest(int cursorId);

    /**
     * 读取更多，抛出事件 PB{{_tbi_.entityName}}ListResultEvent
     * @param page 页码
     * @param cursorId 时间戳
     */
    void findMore(int page, int cursorId);

    /**
     * 读取详细. 抛出事件 PB{{_tbi_.entityName}}DetailResultEvent
     * @param itemId 记录主键
     * @param withRef 是否返回相关联的对象
     */
    void findBy({{_tbi_.pkCol.valType}} itemId, boolean withRef);

    /**
     * 从服务器加载详细. 抛出事件 PB{{_tbi_.entityName}}DetailResultEvent
     * @param itemId 记录主键
     */
    void loadBy({{_tbi_.pkCol.valType}} itemId);

    /**
     * 新建记录. 抛出事件 PB{{_tbi_.entityName}}CreateResultEvent
     * @param item 记录
     */
    void create(PB{{_tbi_.entityName}} item);

    /**
     * 保存修改记录. 抛出事件 PB{{_tbi_.entityName}}SaveResultEvent
     * @param item 记录
     */
    void save(PB{{_tbi_.entityName}} item);

    /**
     * 删除记录. 抛出事件 PB{{_tbi_.entityName}}RemoveResultEvent
     * @param item 记录
     */
    void remove(PB{{_tbi_.entityName}} item);

}