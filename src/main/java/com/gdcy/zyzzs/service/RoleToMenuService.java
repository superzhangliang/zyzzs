package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.RoleToMenu;

public interface RoleToMenuService {
	
	int deleteByPrimaryKey(Long id);

    int insert(RoleToMenu record);

    int insertSelective(RoleToMenu record);

    RoleToMenu selectByPrimaryKey(Long id);
    
    int updateByPrimaryKeySelective(RoleToMenu record);

    int updateByPrimaryKey(RoleToMenu record);

    List<RoleToMenu> selectByEntity( RoleToMenu record );

    int batchInsert(List<RoleToMenu> list);

	int deleteByMenuIds(Long roleId, List<Long> list);
	
}
