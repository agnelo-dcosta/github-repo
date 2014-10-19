package org.aggi.sqldata;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

public class DatabaseConnectionParser {

	private String filePath;
	private String connName;
	private String userName;
	private String password;
	private String connString;
	
	public DatabaseConnectionParser(String connFilePath)
	{
		
		filePath = connFilePath;
	
		
	}

	public String getConnName() {
		return connName;
	}

	public void setConnName(String connName) {
		this.connName = connName;
	}
	public String getUsername() {
		return userName;
	}

	public void setUsername(String username) {
		this.userName = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getConnString() {
		return connString;
	}

	public void setConnString(String connString) {
		this.connString = connString;
	}

	public Map<String, Connection> createConnectionMap() {
		Map<String,Connection> connMap = new HashMap<String, Connection>();
		try {
			FileReader fr = new FileReader(filePath);
			
			BufferedReader reader = new BufferedReader(fr) ;
		    String line = null;
		    
		    Connection conn = null;
		    while ((line = reader.readLine()) != null) 
		    {
		       // System.out.println(line);
		    	if(line.contains("--Name")){
		    		line = reader.readLine();
		    		 connName = line.trim();
		    		 //reset for new connection
		    		 conn = null; 
		    		 userName = null;
		    		 password = null;
		    		 connString = null;
		    		 System.out.println("\nConnName : " + connName);
		    		 if(connName == null){
		    			 throw new Exception("No Valid connection name in the file");
		    		 }
		    	}
		   // 	 while ((line = reader.readLine()) != null && !line.contains("--Name ")) {
		    		 if(line.contains("--Username"))
				        {
				    	   line = reader.readLine();
				    		 userName = line.trim();
				    		 System.out.println("\nUsername :" + userName);
				    		 if(userName == null){
				    			 throw new Exception("No Valid userName  in the file");
				    		 }
				        }
				       if(line.contains("--Password"))
				        {
				    	   line = reader.readLine();
				    		 password = line.trim();
				    		 System.out.println("\npassword :" + password);
				    		 if(password == null){
				    			 throw new Exception("No Valid password in the file");
				    		 }
				        }
				       if(line.contains("--ConnectionString"))
				        {
				    	   line = reader.readLine();
				    	   connString = line.trim();
				    		 System.out.println("\nconnString :" + connString);
				    		 if(connString == null || password == null || userName == null) {
				    			 throw new Exception("No Valid connString in the file");
				    		 }else{
				    			 conn = new DatabaseConn().getConnection(connString, userName, password);
				  		       connMap.put(connName, conn);
				  		     conn = null; 
				    		 userName = null;
				    		 password = null;
				    		 connString = null;
				    		 connName = null;
				  		       
				    		 }
				        }
		    	// }
		    	
		    } 
		}catch (IOException x) {
		    System.err.println(x);
		}
		catch(Exception e)
		{
			System.err.println(e);
		}
		return connMap;
	}
	
}
