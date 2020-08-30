package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginInputsRecord;

public interface OriginInputsRecordService {
    int deleteByPrimaryKey(Long id);

    int insert(OriginInputsRecord record);

    int insertSelective(OriginInputsRecord record);

    OriginInputsRecord selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginInputsRecord record);

    int updateByPrimaryKey(OriginInputsRecord record);

	int countByEntity(OriginInputsRecord record);

	List<OriginInputsRecord> selectByEntity(OriginInputsRecord record);
    
}
