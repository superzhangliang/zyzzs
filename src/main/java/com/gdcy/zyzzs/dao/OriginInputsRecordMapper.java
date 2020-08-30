package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginInputsRecord;

public interface OriginInputsRecordMapper {
    int deleteByPrimaryKey(Long id);

    int insert(OriginInputsRecord record);

    int insertSelective(OriginInputsRecord record);

    OriginInputsRecord selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginInputsRecord record);

    int updateByPrimaryKey(OriginInputsRecord record);

	List<OriginInputsRecord> selectByEntity(OriginInputsRecord record);

	int countByEntity(OriginInputsRecord record);
}