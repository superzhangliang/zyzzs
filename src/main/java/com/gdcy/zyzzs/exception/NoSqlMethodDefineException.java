package com.gdcy.zyzzs.exception;

@SuppressWarnings("serial")
public class NoSqlMethodDefineException extends RuntimeException {
	public NoSqlMethodDefineException() {
		super("数据库方法未定义");
	}
	
	public NoSqlMethodDefineException(String arg0) {
		super(arg0);
	}
	
	public NoSqlMethodDefineException(Throwable arg0) {
		super(arg0);
	}
	
	public NoSqlMethodDefineException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}
}
