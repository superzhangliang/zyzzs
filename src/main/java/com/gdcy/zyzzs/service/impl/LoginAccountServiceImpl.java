package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.LoginAccountMapper;
import com.gdcy.zyzzs.pojo.LoginAccount;
import com.gdcy.zyzzs.service.LoginAccountService;

@Service("LoginAccountServer")
public class LoginAccountServiceImpl implements LoginAccountService {
	
	@Resource
	private LoginAccountMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(LoginAccount record) {
		return mapper.insert(record);
	}

	@Override
	public int insertSelective(LoginAccount record) {
		return mapper.insertSelective(record);
	}

	@Override
	public LoginAccount selectByPrimaryKey(Long id) {
		return mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(LoginAccount record) {
		return mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(LoginAccount record) {
		return mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<LoginAccount> selectByEntity(LoginAccount record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(LoginAccount record){
		return this.mapper.countByEntity(record);
	}

	@Override
	public LoginAccount LoginByAP(LoginAccount record) {
		return this.mapper.LoginByAP(record);
	}
}
