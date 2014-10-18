package org.aggi.sqldata;

public class ServiceException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ServiceException(Throwable arg) {
		super(arg);
	}
	
	public ServiceException(String arg) {
		super(arg);
	}
}
