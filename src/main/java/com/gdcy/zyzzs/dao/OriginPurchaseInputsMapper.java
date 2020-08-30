package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.OriginPurchaseInputs;

public interface OriginPurchaseInputsMapper {
    int deleteByPrimaryKey(Long id);

    int insert(OriginPurchaseInputs record);

    int insertSelective(OriginPurchaseInputs record);

    OriginPurchaseInputs selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(OriginPurchaseInputs record);

    int updateByPrimaryKey(OriginPurchaseInputs record);
    
    List<OriginPurchaseInputs> selectByEntity(OriginPurchaseInputs record);

	int countByEntity(OriginPurchaseInputs record);
}