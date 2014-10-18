package org.aggi.sqldata.test;

import org.aggi.sqldata.SQLFileParser;
import org.junit.Test;

public class SQLFileParserTest {
 SQLFileParser sfp = new SQLFileParser("/test.sql");
 @Test
 public void testParser(){
	 System.out.print("Testing");
	 try {
		sfp.createListOfQueries();
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	 sfp.printQuery();
 }
}
