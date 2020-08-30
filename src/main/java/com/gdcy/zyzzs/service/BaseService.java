package com.gdcy.zyzzs.service;

import java.util.List;

public interface BaseService<K, T> {
	/**
	 * 根据主键删除对象
	 * @param id	主键
	 * @return	影响的记录数
	 */
	int deleteByPrimaryKey(K id);

	/**
	 * 全字段方式插入实体
	 * @param record	实体对象
	 * @return	影响的记录数
	 */
    int insert(T record);

    /**
     * 非空字段方式插入实体
     * @param record	实体对象
     * @return	影响的记录数
     */
    int insertSelective(T record);

    /**
     * 根据主键查找具体对象
     * @param id	主键
     * @return	主键对应的实体
     */
    T selectByPrimaryKey(K id);

    /**
     * 根据主键更新对象非空字段
     * @param record	需更新的对象,主键不能为空
     * @return	影响的记录数
     */
    int updateByPrimaryKeySelective(T record);

    /**
     * 根据主键更新对象所有字段
     * @param record	需更新的对象,主键不能为空
     * @return	影响的记录数
     */
    int updateByPrimaryKey(T record);
    
    /**
     * 根据传入对象的条件查询满足条件的实体集合
     * @param record	查询对象
     * @return	满足条件的实体集合
     */
    List<T> selectByEntity(T record);
    
    /**
     * 根据传入对象的条件查询满足条件的记录数
     * @param record	查询对象
     * @return	满足条件的记录数
     */
    int countByEntity(T record);
    
    /**
     * 删除主键集合的所有实体对象
     * @param ids	需删除的主键集合
     * @return	影响的记录数
     */
    int deleteByPrimaryKeys(List<K> ids);
}
