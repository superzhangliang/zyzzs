package com.gdcy.zyzzs.excel;

import com.gdcy.zyzzs.excel.handler.IExcelHandler;

/**
 * Handler類的工廠，反射創建類實例處理excel數據
 * @author 黃枝良
 *
 * @param <T>
 */
public class ExcelHandlerFactory<T extends IExcelHandler> {

	@SuppressWarnings("unchecked")
	public T create(String className) throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		Class<?> clazz=Class.forName(className);
		return (T) clazz.newInstance();
	}
	
	public String execute(String className,String value) throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		T t=this.create(className);
		return t.execute(value);
	}
	
	/*public class GMTDateHandler implements IExcelHandler{

		public GMTDateHandler(){
			
		}
		
		@Override
		public String execute(String value) {
			return DateUtil.transferGMT(value,null);
		}		
	}*/
}
