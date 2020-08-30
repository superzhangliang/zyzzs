package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginBatchInfo;
import com.gdcy.zyzzs.pojo.Report;
import com.gdcy.zyzzs.pojo.StatisticObject;

public interface OriginBatchInfoService {
    int deleteByPrimaryKey(Long id);

    int insert(OriginBatchInfo record);

    int insertSelective(OriginBatchInfo record);

    OriginBatchInfo selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginBatchInfo record);

    int updateByPrimaryKey(OriginBatchInfo record);

	int countByEntity(OriginBatchInfo record);

	List<OriginBatchInfo> selectByEntity(OriginBatchInfo record);

	int batchUpdateIsReport(Report report);
	
	List<Object> staticAllGoods(StatisticObject record);

}
