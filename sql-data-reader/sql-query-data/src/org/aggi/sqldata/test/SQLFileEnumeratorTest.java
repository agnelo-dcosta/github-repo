package org.aggi.sqldata.test;

import java.io.*;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import junit.framework.Assert;

import org.aggi.sqldata.SQLFileEnumerator;
import org.aggi.sqldata.impl.PropertyConfigReader;
import org.junit.Test;

public class SQLFileEnumeratorTest {

	SQLFileEnumerator sfe = new SQLFileEnumerator();
	 @Test
	 public void testParser(){
		 System.out.print("Testing");
		 try {
			 Properties prop = PropertyConfigReader.read();
			String sqlFileBasePath = prop.getProperty(PropertyConfigReader.SQL_FILES_PATH);
			Map<String,Set<String>> testVariables =  sfe.getVariablesInSQLFiles(new File(sqlFileBasePath));
			if(testVariables == null)
			{
				System.out.println("Error in retriving variables ");
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	 }
	}
