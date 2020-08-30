package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.RoleMapper;
import com.gdcy.zyzzs.pojo.Role;
import com.gdcy.zyzzs.service.RoleService;

@Service("RoleService")
public class RoleServiceImpl implements RoleService {
	
	@Resource
	private RoleMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(Role record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(Role record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public Role selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Role record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Role record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<Role> selectByEntity(Role record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(Role record) {
		return this.mapper.countByEntity(record);
	}

	@Override
	public Integer isManager(Long accountId) {
		return this.mapper.isManager(accountId);
	}


}
