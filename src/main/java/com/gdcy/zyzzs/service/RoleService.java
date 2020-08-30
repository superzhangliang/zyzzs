package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.Role;

public interface RoleService {
    int deleteByPrimaryKey(Long id);

    int insert(Role record);

    int insertSelective(Role record);

    Role selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Role record);

    int updateByPrimaryKey(Role record);
    
    List<Role> selectByEntity( Role record );
    
    int countByEntity( Role record );

    Integer isManager( Long accountId );
}
