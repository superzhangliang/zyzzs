package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.GoodsInfo;

public interface GoodsInfoService extends BaseService<Long, GoodsInfo> {

    List<GoodsInfo> selectByEntity( GoodsInfo record );
    
    int countByEntity( GoodsInfo record );
    
}
