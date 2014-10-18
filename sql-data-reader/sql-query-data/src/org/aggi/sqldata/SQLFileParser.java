package org.aggi.sqldata;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class SQLFileParser {

	private static String filePath;
	Map<String,SqlQueryObject> sqlQueryMap;
	SqlQueryObject newQuery;
	String query = "";
	public SQLFileParser(String sqlFilePath)
	{
		String currentDirectory = System.getProperty("user.dir");
	    System.out.println(currentDirectory);
		filePath = currentDirectory + "/resource/sql-files/" +sqlFilePath;
		
	}
	
	public void createListOfQueries(){
		sqlQueryMap = new HashMap<String,SqlQueryObject >();
		try 
		{
			FileReader fr = new FileReader(filePath);
			BufferedReader reader = new BufferedReader(fr) ;
		    String line = null;
		    while ((line = reader.readLine()) != null) 
		    {
		       // System.out.println(line);
		        if(line.contains("--"))
		        {
		        	String key = line;
		        	newQuery = new SqlQueryObject();
		        	newQuery.setQuery(query);
		        	sqlQueryMap.put(key,newQuery);
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
		for(int i=0; i <= sqlQueryMap.size(); i++ )
		{
			newQuery = sqlQueryMap.get(i);
			System.out.println("\nIndex:" + i + "\nsql:" + newQuery.getQuery());
		}
	}
}
