package org.aggi.sqldata;

import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DatabaseReader {

	String fileName;
	List <SqlQueryObject> queryList;
	String database;
	Map <String,String> variables;
	Connection conn;
	String ssn;
	
	public Map<String, ResultSet> executetQueryList() throws SQLException
	{
		Statement st;
		ResultSet rs;
		Map<String,ResultSet> resultSetMap = new HashMap<String, ResultSet>();
		for(SqlQueryObject queryObject: queryList)
		{
			st = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			rs = st.executeQuery(queryObject.getQuery());
			resultSetMap.put(queryObject.getName(), rs);
		}
		return resultSetMap;
	}
	
	public void setUpReader(String databaseName, Connection conn, String ssn, List <SqlQueryObject> queryList)
	{
		this.conn = conn;
		this.queryList = queryList;
		variables = new HashMap<String,String>();
		
		setupVariables(databaseName, conn, ssn);
		
		replaceVariables();
	}
	
	public void replaceVariables()
	{
		for (SqlQueryObject replaceQuery : queryList)
		{
			for (String variableName : variables.keySet() )
			{
				replaceQuery.setQuery(replaceQuery.getQuery().replaceAll( variableName , variables.get(variableName)));
			}
		}
	}
	
	public void setupVariables(String databaseName, Connection conn, String ssn)
	{
		if(databaseName.equals(Constants.MVAS_Conn_Const))
		{
			// get mvas specific info
			variables.put("<SSN>", ssn);
			
			//get client
			
			//get employer
			
			//get location
			
		}
		
		if(databaseName.equals(Constants.TPA_Conn_Const))
		{
			//get stac specific
			variables.put("<SSN>", ssn.substring(0, 3) + "-" + ssn.substring(3, 5) + "-" + ssn.subSequence(5, 9) );
		
			//get client
			
			
			//get employer
			
			
			//get location
			
		}
		
		if(databaseName.equals(Constants.ES_Conn_Const))
		{
			//get stac event system info
			variables.put("<SSN>", ssn.substring(0, 2) + "-" + ssn.substring(3, 4) + "-" + ssn.subSequence(5, 8) );
		
			//get latest payroll id
			
			//get file UUID
		}
	}
}
