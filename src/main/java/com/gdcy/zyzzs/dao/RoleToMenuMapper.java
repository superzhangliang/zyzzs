package com.gdcy.zyzzs.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.gdcy.zyzzs.pojo.RoleToMenu;

public interface RoleToMenuMapper {
    int deleteByPrimaryKey(Long id);

    int insert(RoleToMenu record);

    int insertSelective(RoleToMenu record);

    RoleToMenu selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(RoleToMenu record);

    int updateByPrimaryKey(RoleToMenu record);
    
    List<RoleToMenu> selectByEntity( RoleToMenu record );
    
    int batchInsert(@Param("list")List<RoleToMenu> list);

	int deleteByMenuIds(@Param("roleId")Long roleId, @Param("list")List<Long> list);
}