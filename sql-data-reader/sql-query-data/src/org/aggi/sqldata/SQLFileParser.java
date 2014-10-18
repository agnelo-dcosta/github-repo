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
	private static String connName;
	private List<SqlQueryObject> sqlQuery;
	SqlQueryObject newQuery;
	
	public SQLFileParser(String sqlFilePath)
	{
		String currentDirectory = System.getProperty("user.dir");
	    System.out.println(currentDirectory);
		filePath = currentDirectory + "/resource/sql-files/" +sqlFilePath;
		
	}
	
	public List<SqlQueryObject> createListOfQueries() throws Exception{
		sqlQuery = new ArrayList<SqlQueryObject >();
		try 
		{
			FileReader fr = new FileReader(filePath);
			BufferedReader reader = new BufferedReader(fr) ;
		    String line = null;
		    String query = "";
		    while ((line = reader.readLine()) != null) 
		    {
		    	line = line.replaceAll("\n", " ").replaceAll("\r", " ");
		    	
		       // System.out.println(line);
		    	if(line.contains("--Connection ")){
		    		
		    		
		    		 connName = getConnectionName(line);
		    		 System.out.println("\nConnName : " + connName);
		    		 if(connName == null){
		    			 throw new Exception("No Valid connection in the file");
		    		 }
		    	}
		    	else if(line.contains("--"))
		        {
		        	String name = line;
		        	newQuery = new SqlQueryObject();
		        	newQuery.setName(name);
		        	query = "";
		        	sqlQuery.add(newQuery);
		        	query = "";
		        }
		        else
		        {
		        	
		        	query = query + " " + line;
		        	query = query.replace(";"," ");
		        	if(newQuery!= null)
		        		newQuery.setQuery(query);
		        }
		        
		    } 
		}catch (IOException x) {
		    System.err.println(x);
		}
		if(sqlQuery == null || sqlQuery.size() == 0){
			throw new Exception("No querries found in the file " + filePath);
		}
		return sqlQuery;
		
	}
	
	private String getConnectionName(String line) {
		String connName = null; 
		for(String conn_const : Constants.conn_Const_List){
			if(line.contains(conn_const)){
				return conn_const;
			}
		}
		
		return connName;
	}

	public void printQuery()
	{
		
		for(int i=0; i < sqlQuery.size(); i++ )
		{
			newQuery = sqlQuery.get(i);
			System.out.println("\nIndex:" + i + "\nname: "+newQuery.getName()+ "\tsql:" + newQuery.getQuery());
		}
	}
	public String getConnName(){
		return connName;
	}
}
