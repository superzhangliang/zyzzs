package com.gdcy.zyzzs.service;

import com.gdcy.zyzzs.pojo.Invalid;

public interface InvalidService {
    int deleteByPrimaryKey(Long id);

    int insert(Invalid record);

    int insertSelective(Invalid record);

    Invalid selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Invalid record);

    int updateByPrimaryKey(Invalid record);


}
