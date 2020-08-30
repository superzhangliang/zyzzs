package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.Menu;

public interface MenuMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Menu record);

    int insertSelective(Menu record);

    Menu selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Menu record);

    int updateByPrimaryKey(Menu record);
    
    List<Menu> selectByEntity(Menu record);
    
    int countByEntity(Menu record);
    
    List<Menu> getMenusByUserId(Long accountId);
    
    List<Menu> getMenusByRoleIds(List<Long> list);
    
	void updateOldOrderNo(Menu menu );
	
	void updateAllOrderNo(Menu menu);
	
	void updateSelfOrderNo(Menu menu);
	
	void deleteByIds(List<Long> menunodes);
	
}