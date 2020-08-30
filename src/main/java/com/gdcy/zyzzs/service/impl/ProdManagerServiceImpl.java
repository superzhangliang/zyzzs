package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.ProdManagerMapper;
import com.gdcy.zyzzs.pojo.ProdManager;
import com.gdcy.zyzzs.service.ProdManagerService;

@Service("ProdManagerService")
public class ProdManagerServiceImpl implements ProdManagerService {
	
	@Resource
	private ProdManagerMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(ProdManager record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(ProdManager record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public ProdManager selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(ProdManager record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(ProdManager record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<ProdManager> selectByEntity(ProdManager record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(ProdManager record) {
		return this.mapper.countByEntity(record);
	}

}
