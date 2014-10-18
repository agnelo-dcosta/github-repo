package org.aggi.sqldata.test;

import org.aggi.sqldata.SQLFileParser;
import org.junit.Test;

public class SQLFileParserTest {
 SQLFileParser sfp = new SQLFileParser("/mvas.txt");
 @Test
 public void testParser(){
	 System.out.print("Testing");
	 sfp.printQuery();
 }
}
