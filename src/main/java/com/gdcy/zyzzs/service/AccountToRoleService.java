package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.AccountToRole;

public interface AccountToRoleService extends BaseService<Long, AccountToRole> {

    List<AccountToRole> selectByEntity( AccountToRole record );
    
    int countByEntity( AccountToRole record );

    int delByAccIdAndRoleId(AccountToRole delAcc);
    
}
