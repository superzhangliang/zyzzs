package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.Business;

/**
 * 经营者/个体户基本信息
 *
 */
public interface BusinessService extends BaseService<Long, Business> {

    List<Business> selectByEntity( Business record );
    
    int countByEntity( Business record );
    
}
