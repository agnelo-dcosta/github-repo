package org.aggi.sqldata;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class DatabaseConnectionParser {

	private String filePath;
	private String connName;
	private String userName;
	private String password;
	private String connString;
	
	public DatabaseConnectionParser(String connFilePath)
	{
		String currentDirectory = System.getProperty("user.dir");
	    System.out.println(currentDirectory);
		filePath = currentDirectory + "/resource/conn-files/" + connFilePath;
	
		try {
			FileReader fr = new FileReader(filePath);
			BufferedReader reader = new BufferedReader(fr) ;
		    String line = null;
		    String query = "";
		    while ((line = reader.readLine()) != null) 
		    {
		       // System.out.println(line);
		    	if(line.contains("--Name ")){
		    		line = reader.readLine();
		    		 connName = line.trim();
		    		 System.out.println("\nConnName : " + connName);
		    		 if(connName == null){
		    			 throw new Exception("No Valid connection name in the file");
		    		 }
		    	}
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
		    		 if(connString == null){
		    			 throw new Exception("No Valid connString in the file");
		    		 }
		        }
		    } 
		}catch (IOException x) {
		    System.err.println(x);
		}
		catch(Exception e)
		{
			System.err.println(e);
		}
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
		
}
