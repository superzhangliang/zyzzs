package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.OriginHarvestInfoMapper;
import com.gdcy.zyzzs.pojo.OriginHarvestInfo;
import com.gdcy.zyzzs.service.OriginHarvestInfoService;

@Service("OriginHarvestInfoService")
public class OriginHarvestInfoServiceImpl implements OriginHarvestInfoService {
	
	@Resource
	private OriginHarvestInfoMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(OriginHarvestInfo record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(OriginHarvestInfo record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public OriginHarvestInfo selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(OriginHarvestInfo record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(OriginHarvestInfo record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<OriginHarvestInfo> selectByEntity(OriginHarvestInfo record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(OriginHarvestInfo record) {
		return this.mapper.countByEntity(record);
	}

}
