package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.RoleToMenuMapper;
import com.gdcy.zyzzs.pojo.RoleToMenu;
import com.gdcy.zyzzs.service.RoleToMenuService;

@Service("RoleToMenuServer")
public class RoleToMenuServiceImpl implements RoleToMenuService {
	
	@Resource
	private RoleToMenuMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(RoleToMenu record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(RoleToMenu record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public RoleToMenu selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(RoleToMenu record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(RoleToMenu record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<RoleToMenu> selectByEntity(RoleToMenu record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int batchInsert(List<RoleToMenu> list) {
		return this.mapper.batchInsert(list);
	}

	@Override
	public int deleteByMenuIds(Long roleId, List<Long> list) {
		return this.mapper.deleteByMenuIds(roleId, list);
	}


}
