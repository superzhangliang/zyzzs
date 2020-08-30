package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.LoginAccount;

public interface LoginAccountService {
	
	int deleteByPrimaryKey(Long id);

    int insert(LoginAccount record);

    int insertSelective(LoginAccount record);

    LoginAccount selectByPrimaryKey(Long id);
    
    int updateByPrimaryKeySelective(LoginAccount record);

    int updateByPrimaryKey(LoginAccount record);

    List<LoginAccount> selectByEntity(LoginAccount record);
    
    int countByEntity(LoginAccount record);
  
    LoginAccount LoginByAP(LoginAccount record);
}
