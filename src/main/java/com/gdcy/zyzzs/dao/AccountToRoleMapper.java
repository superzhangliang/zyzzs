package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.AccountToRole;

public interface AccountToRoleMapper {
    int deleteByPrimaryKey(Long id);

    int insert(AccountToRole record);

    int insertSelective(AccountToRole record);

    AccountToRole selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(AccountToRole record);

    int updateByPrimaryKey(AccountToRole record);

    List<AccountToRole> selectByEntity( AccountToRole record );
    
    int countByEntity( AccountToRole record );
    
	int delByAccIdAndRoleId(AccountToRole delAcc);
}