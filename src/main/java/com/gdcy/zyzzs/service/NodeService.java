package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.Node;

/**
 * 节点基本信息
 *
 */
public interface NodeService extends BaseService<Long, Node> {
    
	List<Node> selectByEntity(Node record);
    
    int countByEntity(Node record);
    
}
