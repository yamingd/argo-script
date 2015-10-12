package com._company_._project_.service;

import com.argo.db.exception.EntityNotFoundException;
import com.argo.security.UserIdentity;
import com.argo.service.ServiceException;

import java.io.Serializable;
import java.util.List;

/**
 * Created by yamingd on 9/20/15.
 */
public interface ServiceBase<T extends Serializable, PK extends Comparable> {
    /**
     *
     * @param id
     * @return T
     */
    T find(UserIdentity user, PK id) throws EntityNotFoundException;

    /**
     *
     * @param ids
     * @return List
     */
    List<T> findList(UserIdentity user, PK... ids);

    /**
     * 新建记录
     * @param item
     * @return T
     */
    T create(UserIdentity user, T item) throws ServiceException;

    /**
     * 保存更新
     * @param item
     * @return boolean
     */
    T save(UserIdentity user, T item) throws ServiceException;

    /**
     * 删除记录
     * @param id
     * @return boolean
     */
    boolean removeBy(UserIdentity user, PK id) throws ServiceException;

    /**
     * 删除记录
     * @param item
     * @return boolean
     */
    boolean remove(UserIdentity user, T item) throws ServiceException;
}