package org.aggi.sqldata;

import java.sql.*;
import java.util.Properties;

public class Runner {

	public static void main(String args[])
	{
		System.out.println("Starting Data Reader");
//		SQLFileParser fileParser = new SQLFileParser("mvas.txt");
//		fileParser.printQuery();
		
		ConnectionTest();
	}
		
	public static void ConnectionTest()
	{
		try{
		DatabaseConn  dbconn= new DatabaseConn();
		Connection conn = dbconn.getConnection("jdbc:oracle:thin:@EISORA001:1522:tiaa001", "AGGI2", "AGGI2_123");
		Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		 
		ResultSet rs = stmt.executeQuery("select * from customer");
		rs.first();
	      System.out.println("rows before batch execution= " + rs.getString("customerId") );
	      
		conn.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	

}


