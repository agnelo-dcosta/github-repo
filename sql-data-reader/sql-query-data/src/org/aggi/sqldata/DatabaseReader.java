package org.aggi.sqldata;

import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DatabaseReader {

	String fileName;
	private static List <SqlQueryObject> queryList;
	String databaseName;
	private static Map <String,String> variables;
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
	
	public void setUpReader( Connection conn,String databaseName,Map <String,String> variables, List <SqlQueryObject> queryList)
	{
		this.conn = conn;
		this.queryList = queryList;
		this.databaseName = databaseName;
		this.variables = variables;
		
		replaceVariables();
		
	}
	
	public void replaceVariables()
	{
		for (SqlQueryObject replaceQuery : queryList)
		{
			for (String variableName : variables.keySet() )
			{
				if(variableName.equals("<SSN>") && databaseName.equals(Constants.TPA_Conn_Const)){
					replaceQuery.setQuery(replaceQuery.getQuery().replaceAll( variableName , 
							variables.get(variableName).substring(0, 3) + "-" + variables.get(variableName).substring(3, 5) + "-" + variables.get(variableName).subSequence(5, 9)));
				}else{

					replaceQuery.setQuery(replaceQuery.getQuery().replaceAll( variableName , variables.get(variableName)));
				}
				
				
			}
		}
	}
	
}
