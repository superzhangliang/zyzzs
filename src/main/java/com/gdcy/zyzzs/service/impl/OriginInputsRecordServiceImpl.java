package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.OriginInputsRecordMapper;
import com.gdcy.zyzzs.pojo.OriginInputsRecord;
import com.gdcy.zyzzs.service.OriginInputsRecordService;

@Service("OriginInputsRecordService")
public class OriginInputsRecordServiceImpl implements OriginInputsRecordService {
	
	@Resource
	private OriginInputsRecordMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(OriginInputsRecord record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(OriginInputsRecord record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public OriginInputsRecord selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(OriginInputsRecord record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(OriginInputsRecord record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<OriginInputsRecord> selectByEntity(OriginInputsRecord record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(OriginInputsRecord record) {
		return this.mapper.countByEntity(record);
	}

}
