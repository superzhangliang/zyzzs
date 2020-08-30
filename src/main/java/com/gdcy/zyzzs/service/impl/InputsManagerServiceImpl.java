package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.InputsManagerMapper;
import com.gdcy.zyzzs.pojo.InputsManager;
import com.gdcy.zyzzs.pojo.NumChangeRecord;
import com.gdcy.zyzzs.service.InputsManagerService;

@Service("InputsManagerService")
public class InputsManagerServiceImpl implements InputsManagerService {
	
	@Resource
	private InputsManagerMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(InputsManager record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(InputsManager record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public InputsManager selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(InputsManager record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(InputsManager record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public List<InputsManager> selectByEntity(InputsManager record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(InputsManager record) {
		return this.mapper.countByEntity(record);
	}

	@Override
	public List<NumChangeRecord> selectNumChangeRecord(NumChangeRecord record) {
		return this.mapper.selectNumChangeRecord(record);
	}

	@Override
	public Integer countNumChangeRecord(NumChangeRecord record) {
		return this.mapper.countNumChangeRecord(record);
	}

}
