package org.aggi.sqldata;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class SQLFileParser {

	private static String filePath;
	List<SqlQueryObject> sqlQuery;
	SqlQueryObject newQuery;
	String query = "";
	public SQLFileParser(String sqlFilePath)
	{
		filePath = "resource/sql-files/" + sqlFilePath;
		sqlQuery = new ArrayList();
		try 
		{
			FileReader fr = new FileReader(filePath);
			BufferedReader reader = new BufferedReader(fr) ;
		    String line = null;
		    while ((line = reader.readLine()) != null) 
		    {
		       // System.out.println(line);
		        if(line.contains("#"))
		        {
		        	newQuery = new SqlQueryObject();
		        	newQuery.setQuery(query);
		        	sqlQuery.add(newQuery);
		        	query = "";
		        }
		        else
		        {
		        	query = query + line;
		        }
		        
		    } 
		}catch (IOException x) {
		    System.err.println(x);
		}
	}
	
	public void printQuery()
	{
		for(int i=0; i < sqlQuery.size(); i++ )
		{
			newQuery = sqlQuery.get(i);
			System.out.println("\nIndex:" + i + "\nsql:" + newQuery.getQuery());
		}
	}
}
