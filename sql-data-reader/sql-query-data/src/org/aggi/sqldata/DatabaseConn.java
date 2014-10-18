package org.aggi.sqldata;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DatabaseConn {

	Connection conn;
	
	public Connection getConnection(String connString, String username, String password)
	{	
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(
				connString,username,password);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return conn;
	}
	
}
