package org.aggi.sqldata;

import java.io.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SQLFileEnumerator {

	public static List<String> listSQLFilesInFolder(final String sqlFilespath) {
		final File folder = new File(sqlFilespath);
		return listSQLFilesInFolder(folder);
	}
	
	public static List<String> listSQLFilesInFolder(final File folder) {
		List<String> sqlFiles = new ArrayList<String>();
		
	    for (final File fileEntry : folder.listFiles()) {
	    	if (fileEntry.isDirectory()) {
	    		//listSQLFilesInFolder(fileEntry);
	        } else {
	            sqlFiles.add(fileEntry.getName());
	        }
	    }
	    return sqlFiles;
	}
	
	public static Map<String,Set<String>> getVariablesInSQLFiles(final String sqlFilespath) throws ServiceException {
		final File folder = new File(sqlFilespath);
		return getVariablesInSQLFiles(folder);
	}
	
	public static Map<String,Set<String>> getVariablesInSQLFiles(final File folder) throws ServiceException {
		Map<String,Set<String>> variableMap = new HashMap<String,Set<String>>();
		Pattern patt = Pattern.compile("<[A-Za-z]+>");
		 for (File fileEntry : folder.listFiles()) {
			 
			 String fileName =  fileEntry.getName(); 
			 
			 Set<String> variableArray = new TreeSet<String>();
			 
			 FileReader fr;
			try {
				fr = new FileReader(fileEntry.getAbsolutePath());
			
				BufferedReader reader = new BufferedReader(fr) ;
			    String line = null;
			    String query = "";
				while ((line = reader.readLine()) != null) 
				{
					Matcher m = patt.matcher(line);
					while(m.find())
					{
					//	System.out.println(line.substring(m.start(0), m.end(0)));
						variableArray.add(line.substring(m.start(0), m.end(0)));
					}
				}
			    variableMap.put(fileName, variableArray);
			} catch (FileNotFoundException ex) {
				throw new ServiceException(ex);
			} catch (IOException ex) {
				throw new ServiceException(ex);
			}
		 }
		
		return variableMap; 
	}

}
