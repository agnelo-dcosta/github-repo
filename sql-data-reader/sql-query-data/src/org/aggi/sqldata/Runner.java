package org.aggi.sqldata;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

public class Runner {

	public static void main(String args[])
	{
		System.out.println("Starting Data Reader");
//		SQLFileParser fileParser = new SQLFileParser("mvas.txt");
//		fileParser.printQuery();
		
		try {
		ConnectionTest();
		
		Connection conn = new DatabaseConn().getConnection("jdbc:oracle:thin:@EISORA001:1522:tiaa001", "AGGI2", "AGGI2_123");
		DatabaseReader dr =  new DatabaseReader();
		List <SqlQueryObject> rsInput = new ArrayList<SqlQueryObject>();
		
		SqlQueryObject testQuery = new SqlQueryObject();
		testQuery.setName("Customer");
		testQuery.setQuery("Select username, customerid, firstname, lastname from customer where username = '<SSN>'");
		
		rsInput.add(testQuery);
		
		dr.setUpReader(Constants.MVAS_Conn_Const, conn, "374952188", rsInput);
		dr.replaceVariables();
		
		List <ResultSet> rsOutput = new ArrayList<ResultSet>();
	
		dr.readSql(rsOutput);
		
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
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


