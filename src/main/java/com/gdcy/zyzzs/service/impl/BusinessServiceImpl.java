package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.BusinessMapper;
import com.gdcy.zyzzs.pojo.Business;
import com.gdcy.zyzzs.service.BusinessService;

@Service
public class BusinessServiceImpl implements BusinessService {
	@Resource
	private BusinessMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(Business record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(Business record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public Business selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Business record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Business record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<Business> selectByEntity(Business record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(Business record) {
		return this.mapper.countByEntity(record);
	}

	@Override
	public int deleteByPrimaryKeys(List<Long> ids) {
		return 0;
	}

}
