package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.OriginPurchaseInputsMapper;
import com.gdcy.zyzzs.pojo.OriginPurchaseInputs;
import com.gdcy.zyzzs.service.OriginPurchaseInputsService;

@Service("OriginPurchaseInputsService")
public class OriginPurchaseInputsServiceImpl implements OriginPurchaseInputsService {
	
	@Resource
	private OriginPurchaseInputsMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(OriginPurchaseInputs record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(OriginPurchaseInputs record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public OriginPurchaseInputs selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(OriginPurchaseInputs record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(OriginPurchaseInputs record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<OriginPurchaseInputs> selectByEntity(OriginPurchaseInputs record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(OriginPurchaseInputs record) {
		return this.mapper.countByEntity(record);
	}

}
