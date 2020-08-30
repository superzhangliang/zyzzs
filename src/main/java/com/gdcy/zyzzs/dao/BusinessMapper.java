package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.Business;

public interface BusinessMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Business record);

    int insertSelective(Business record);

    Business selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Business record);

    int updateByPrimaryKey(Business record);
    
    List<Business> selectByEntity( Business record );
    
    int countByEntity( Business record );
    
}