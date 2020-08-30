package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.Area;

public interface AreaMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Area record);

    int insertSelective(Area record);

    Area selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Area record);

    int updateByPrimaryKey(Area record);

	List<Area> selectByEntity(Area record);

	int deleteByPrimaryKeys(List<Long> ids);

	int countByEntity(Area record);
}