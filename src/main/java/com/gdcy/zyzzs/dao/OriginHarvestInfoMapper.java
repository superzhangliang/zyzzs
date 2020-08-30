package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginHarvestInfo;

public interface OriginHarvestInfoMapper {
    int deleteByPrimaryKey(Long id);

    int insert(OriginHarvestInfo record);

    int insertSelective(OriginHarvestInfo record);

    OriginHarvestInfo selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginHarvestInfo record);

    int updateByPrimaryKey(OriginHarvestInfo record);

	List<OriginHarvestInfo> selectByEntity(OriginHarvestInfo record);

	int countByEntity(OriginHarvestInfo record);
}