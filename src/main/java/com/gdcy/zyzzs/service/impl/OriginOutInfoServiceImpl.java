package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.OriginOutInfoMapper;
import com.gdcy.zyzzs.pojo.OriginOutInfo;
import com.gdcy.zyzzs.service.OriginOutInfoService;

@Service("OriginOutInfoService")
public class OriginOutInfoServiceImpl implements OriginOutInfoService {
	
	@Resource
	private OriginOutInfoMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(OriginOutInfo record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(OriginOutInfo record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public OriginOutInfo selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(OriginOutInfo record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(OriginOutInfo record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<OriginOutInfo> selectByEntity(OriginOutInfo record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(OriginOutInfo record) {
		return this.mapper.countByEntity(record);
	}

}
