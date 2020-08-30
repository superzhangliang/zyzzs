package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.GoodsInfoMapper;
import com.gdcy.zyzzs.pojo.GoodsInfo;
import com.gdcy.zyzzs.service.GoodsInfoService;

@Service
public class GoodsInfoServiceImpl implements GoodsInfoService {
	@Resource
	private GoodsInfoMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(GoodsInfo record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(GoodsInfo record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public GoodsInfo selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(GoodsInfo record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(GoodsInfo record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<GoodsInfo> selectByEntity(GoodsInfo record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(GoodsInfo record) {
		return this.mapper.countByEntity(record);
	}

	@Override
	public int deleteByPrimaryKeys(List<Long> ids) {
		return 0;
	}

}
