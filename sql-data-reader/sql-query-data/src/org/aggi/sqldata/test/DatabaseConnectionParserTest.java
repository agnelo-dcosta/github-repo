package org.aggi.sqldata.test;

import org.aggi.sqldata.DatabaseConnectionParser;
import org.junit.Test;

public class DatabaseConnectionParserTest {
	
 @Test
 public void testParser(){
	 System.out.print("Testing");
	 try {
		 DatabaseConnectionParser dcp = new DatabaseConnectionParser("mvas-conn.txt");
		System.out.println( dcp.getConnName() + dcp.getUsername() + dcp.getPassword() + dcp.getConnString()); 
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	
 }
}
