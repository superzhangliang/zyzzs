package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.ProdManager;

public interface ProdManagerService {
    int deleteByPrimaryKey(Long id);

    int insert(ProdManager record);

    int insertSelective(ProdManager record);

    ProdManager selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(ProdManager record);

    int updateByPrimaryKey(ProdManager record);

	int countByEntity(ProdManager record);

	List<ProdManager> selectByEntity(ProdManager record);
    
}
