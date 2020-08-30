package com.gdcy.zyzzs.dao;

import java.util.List;

import com.gdcy.zyzzs.pojo.GoodsInfo;

public interface GoodsInfoMapper {
    int deleteByPrimaryKey(Long id);

    int insert(GoodsInfo record);

    int insertSelective(GoodsInfo record);

    GoodsInfo selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(GoodsInfo record);

    int updateByPrimaryKey(GoodsInfo record);
    
    List<GoodsInfo> selectByEntity( GoodsInfo record );
    
    int countByEntity( GoodsInfo record );
}