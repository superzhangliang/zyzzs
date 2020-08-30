package com.gdcy.zyzzs.excel.export.handler;

import java.util.List;

/**
 * Handler類接口
 * @author 
 *
 */
@SuppressWarnings("rawtypes")
public interface IReportHandler<T> {
	
	public List transFormation(T value, String type);
}