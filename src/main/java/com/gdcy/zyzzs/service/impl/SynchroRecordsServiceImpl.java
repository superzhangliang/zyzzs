package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.SynchroRecordsMapper;
import com.gdcy.zyzzs.pojo.SynchroRecords;
import com.gdcy.zyzzs.service.SynchroRecordsService;

@Service
public class SynchroRecordsServiceImpl implements SynchroRecordsService {
	@Resource
	private SynchroRecordsMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(SynchroRecords record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(SynchroRecords record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public SynchroRecords selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(SynchroRecords record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(SynchroRecords record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<SynchroRecords> selectByEntity(SynchroRecords record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(SynchroRecords record) {
		return this.mapper.countByEntity(record);
	}

}
