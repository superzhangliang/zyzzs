package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.Node;

public interface NodeMapper {
    int deleteByPrimaryKey(Long id);

    int insert(Node record);

    int insertSelective(Node record);

    Node selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Node record);

    int updateByPrimaryKey(Node record);
    
    List<Node> selectByEntity(Node record);
    
    int countByEntity(Node record);
}