package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.AreaMapper;
import com.gdcy.zyzzs.pojo.Area;
import com.gdcy.zyzzs.service.AreaService;

@Service
public class AreaServiceImpl implements AreaService {
	@Resource
	private AreaMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(Area record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(Area record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public Area selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Area record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Area record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<Area> selectByEntity(Area record) {
		return this.mapper.selectByEntity(record);
	}


	@Override
	public int deleteByPrimaryKeys(List<Long> ids) {
		return this.mapper.deleteByPrimaryKeys(ids);
	}

	@Override
	public int countByEntity(Area record) {
		return this.mapper.countByEntity(record);
	}

}
