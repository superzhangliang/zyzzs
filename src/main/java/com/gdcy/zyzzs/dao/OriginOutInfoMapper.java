package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginOutInfo;

public interface OriginOutInfoMapper {
    int deleteByPrimaryKey(Long id);

    int insert(OriginOutInfo record);

    int insertSelective(OriginOutInfo record);

    OriginOutInfo selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginOutInfo record);

    int updateByPrimaryKey(OriginOutInfo record);

	List<OriginOutInfo> selectByEntity(OriginOutInfo record);

	int countByEntity(OriginOutInfo record);
}