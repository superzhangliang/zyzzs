package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.ProdManager;

public interface ProdManagerMapper {
    int deleteByPrimaryKey(Long id);

    int insert(ProdManager record);

    int insertSelective(ProdManager record);

    ProdManager selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(ProdManager record);

    int updateByPrimaryKey(ProdManager record);

	List<ProdManager> selectByEntity(ProdManager record);

	int countByEntity(ProdManager record);
}