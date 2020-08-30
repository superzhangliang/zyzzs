package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.AccountToRoleMapper;
import com.gdcy.zyzzs.pojo.AccountToRole;
import com.gdcy.zyzzs.service.AccountToRoleService;

@Service("AccountToRoleServer")
public class AccountToRoleServiceImpl implements AccountToRoleService {
	
	@Resource
	private AccountToRoleMapper mapper;

	@Override
	public int insert(AccountToRole record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(AccountToRole record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public int updateByPrimaryKeySelective(AccountToRole record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(AccountToRole record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public AccountToRole selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public List<AccountToRole> selectByEntity(AccountToRole record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(AccountToRole record) {
		return this.mapper.countByEntity(record);
	}

	@Override
	public int deleteByPrimaryKeys(List<Long> ids) {
		return 0;
	}

	@Override
	public int delByAccIdAndRoleId(AccountToRole delAcc) {
		return this.mapper.delByAccIdAndRoleId(delAcc);
	}

}
