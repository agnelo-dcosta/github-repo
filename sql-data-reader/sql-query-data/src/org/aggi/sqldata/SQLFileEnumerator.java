package org.aggi.sqldata;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

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

}
