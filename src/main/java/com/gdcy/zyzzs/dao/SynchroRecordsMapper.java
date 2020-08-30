package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.SynchroRecords;

public interface SynchroRecordsMapper {
    int deleteByPrimaryKey(Long id);

    int insert(SynchroRecords record);

    int insertSelective(SynchroRecords record);

    SynchroRecords selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(SynchroRecords record);

    int updateByPrimaryKeyWithBLOBs(SynchroRecords record);

    int updateByPrimaryKey(SynchroRecords record);
    
    List<SynchroRecords> selectByEntity(SynchroRecords record);
    
    int countByEntity(SynchroRecords record);
}