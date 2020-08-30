package com.gdcy.zyzzs.service;

import java.util.List;

import com.gdcy.zyzzs.pojo.Area;

/**
 * 区域信息
 *
 */
public interface AreaService extends BaseService<Long, Area> {

    List<Area> selectByEntity( Area record );
    
}
