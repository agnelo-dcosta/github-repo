package org.aggi.sqldata;

import java.sql.*;
import java.util.List;

public class DatabaseReader {

	String fileName;
	List <SqlQueryObject> queryList;
	String database;
	Map <String,String> variables;
	
	public ResultSet readSql(Connection conn, String query) throws SQLException
	{
		Statement st;
		ResultSet rs;
		st = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
		
		rs = st.executeQuery(query);
		
		return rs;
	}
	
	public void setUpReader(String fileName, String databaseName, List <SqlQueryObject> queryList)
	{
		
	}
	
	public void replaceVariables()
	{
		
	}
}
