package com.gdcy.zyzzs.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.InvalidMapper;
import com.gdcy.zyzzs.pojo.Invalid;
import com.gdcy.zyzzs.service.InvalidService;

@Service("InvalidService")
public class InvalidServiceImpl implements InvalidService {
	
	@Resource
	private InvalidMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(Invalid record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(Invalid record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public Invalid selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Invalid record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Invalid record) {
		return this.mapper.updateByPrimaryKey(record);
	}

}
