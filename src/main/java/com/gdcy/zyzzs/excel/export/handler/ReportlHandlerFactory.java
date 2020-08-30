package com.gdcy.zyzzs.excel.export.handler;

import java.util.List;

import com.gdcy.zyzzs.excel.export.handler.IReportHandler;

/**
 * Handler類的工廠，反射創建類實例處理excel數據
 * @author 
 *
 * @param <T>
 */
@SuppressWarnings({"rawtypes","unchecked"})
public class ReportlHandlerFactory<T extends IReportHandler> {

	public T create(String className) throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		Class<?> clazz=Class.forName(className);
		return (T) clazz.newInstance();
	}
	
	public List transFormation(String className,String value,String type) throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		T t=this.create(className);
		return t.transFormation(value,type);
	}

}
