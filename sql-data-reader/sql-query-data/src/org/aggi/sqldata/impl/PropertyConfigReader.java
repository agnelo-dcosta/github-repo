package org.aggi.sqldata.impl;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.aggi.sqldata.ServiceException;

public class PropertyConfigReader {
	private static final String CONFIG_FILE ="config.properties";	
	
	public static Properties read() throws ServiceException {
		
		Properties prop = new Properties();
		InputStream inputStream = PropertyConfigReader.class.getClassLoader().getResourceAsStream(CONFIG_FILE);
		try {
			if (null==inputStream) {
				throw new FileNotFoundException("property file '" + CONFIG_FILE + "' not found in the classpath");
			}
			
			prop.load(inputStream);
		} catch (FileNotFoundException ex) {
			throw new ServiceException(ex);
		} catch (IOException ex) {
			throw new ServiceException(ex);
		}
		
		return prop;
	}
}