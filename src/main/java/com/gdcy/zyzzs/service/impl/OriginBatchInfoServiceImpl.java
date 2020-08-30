package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.OriginBatchInfoMapper;
import com.gdcy.zyzzs.pojo.OriginBatchInfo;
import com.gdcy.zyzzs.pojo.Report;
import com.gdcy.zyzzs.pojo.StatisticObject;
import com.gdcy.zyzzs.service.OriginBatchInfoService;

@Service("OriginBatchInfoService")
public class OriginBatchInfoServiceImpl implements OriginBatchInfoService {
	
	@Resource
	private OriginBatchInfoMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(OriginBatchInfo record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(OriginBatchInfo record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public OriginBatchInfo selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(OriginBatchInfo record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(OriginBatchInfo record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<OriginBatchInfo> selectByEntity(OriginBatchInfo record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(OriginBatchInfo record) {
		return this.mapper.countByEntity(record);
	}

	@Override
	public int batchUpdateIsReport(Report report) {
		return this.mapper.batchUpdateIsReport(report);
	}
	
	@Override
	public List<Object> staticAllGoods(StatisticObject record) {
		return this.mapper.staticAllGoods(record);
	}


}
