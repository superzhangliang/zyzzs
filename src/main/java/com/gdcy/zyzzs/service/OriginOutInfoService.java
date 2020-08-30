package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginOutInfo;

public interface OriginOutInfoService {
    int deleteByPrimaryKey(Long id);

    int insert(OriginOutInfo record);

    int insertSelective(OriginOutInfo record);

    OriginOutInfo selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginOutInfo record);

    int updateByPrimaryKey(OriginOutInfo record);

	int countByEntity(OriginOutInfo record);

	List<OriginOutInfo> selectByEntity(OriginOutInfo record);
    
}
