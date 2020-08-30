package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.MenuMapper;
import com.gdcy.zyzzs.pojo.Menu;
import com.gdcy.zyzzs.service.MenuService;

@Service
public class MenuServiceImpl implements MenuService {
	@Resource
	private MenuMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(Menu record) {
		return mapper.insert(record);
	}

	@Override
	public int insertSelective(Menu record) {
		return mapper.insertSelective(record);
	}

	@Override
	public Menu selectByPrimaryKey(Long id) {
		return mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Menu record) {
		return mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Menu record) {
		return mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<Menu> selectByEntity(Menu record) {
		return mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(Menu record) {
		return mapper.countByEntity(record);
	}

	@Override
	public List<Menu> getMenusByUserId(Long accountId) {
		return mapper.getMenusByUserId(accountId);
	}

	@Override
	public List<Menu> getMenusByRoleIds(List<Long> list) {
		return this.mapper.getMenusByRoleIds(list);
	}
	
	@Override
	public void updateOldOrderNo(Menu menu) {
		this.mapper.updateOldOrderNo(menu);
	}

	@Override
	public void updateAllOrderNo(Menu menu) {
		this.mapper.updateAllOrderNo(menu);
	}

	@Override
	public void updateSelfOrderNo(Menu menu) {
		this.mapper.updateSelfOrderNo(menu);
	}

	@Override
	public void deleteByIds(List<Long> menunodes) {
		this.mapper.deleteByIds(menunodes);
	}

}
