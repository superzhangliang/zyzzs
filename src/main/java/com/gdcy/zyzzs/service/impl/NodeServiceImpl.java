package com.gdcy.zyzzs.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.gdcy.zyzzs.dao.NodeMapper;
import com.gdcy.zyzzs.pojo.Node;
import com.gdcy.zyzzs.service.NodeService;

@Service("NodeService")
public class NodeServiceImpl implements NodeService {
	@Resource
	private NodeMapper mapper;

	@Override
	public int deleteByPrimaryKey(Long id) {
		return this.mapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(Node record) {
		return this.mapper.insert(record);
	}

	@Override
	public int insertSelective(Node record) {
		return this.mapper.insertSelective(record);
	}

	@Override
	public Node selectByPrimaryKey(Long id) {
		return this.mapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateByPrimaryKeySelective(Node record) {
		return this.mapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(Node record) {
		return this.mapper.updateByPrimaryKey(record);
	}

	@Override
	public int deleteByPrimaryKeys(List<Long> ids) {
		return 0;
	}

	@Override
	public List<Node> selectByEntity(Node record) {
		return this.mapper.selectByEntity(record);
	}

	@Override
	public int countByEntity(Node record) {
		return  this.mapper.countByEntity(record);
	}


}
