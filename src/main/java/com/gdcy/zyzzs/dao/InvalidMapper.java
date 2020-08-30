package com.gdcy.zyzzs.dao;

import com.gdcy.zyzzs.pojo.Invalid;

public interface InvalidMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Invalid record);

    int insertSelective(Invalid record);

    Invalid selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Invalid record);

    int updateByPrimaryKey(Invalid record);
}