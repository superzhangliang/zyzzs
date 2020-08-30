package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginHarvestInfo;

public interface OriginHarvestInfoService {
    int deleteByPrimaryKey(Long id);

    int insert(OriginHarvestInfo record);

    int insertSelective(OriginHarvestInfo record);

    OriginHarvestInfo selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginHarvestInfo record);

    int updateByPrimaryKey(OriginHarvestInfo record);

	int countByEntity(OriginHarvestInfo record);

	List<OriginHarvestInfo> selectByEntity(OriginHarvestInfo record);
    
}
