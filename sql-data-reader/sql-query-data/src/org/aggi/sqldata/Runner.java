package org.aggi.sqldata;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.aggi.sqldata.impl.DataExportImpl;
import org.aggi.sqldata.impl.PropertyConfigReader;


public class Runner {

	public void dataExtractorRunner(List<String> sqlFileNameList, Map<String,String> variables, String dbConfigFileName) throws Exception
	{
		 
	
		System.out.println("Starting Data Reader");
		
			Properties prop = PropertyConfigReader.read();
			String sqlFileBasePath = prop.getProperty(PropertyConfigReader.SQL_FILES_PATH);
			String dbConnPath = prop.getProperty(PropertyConfigReader.DB_CONFIG_PATH);
			String outPutFilePath = prop.getProperty(PropertyConfigReader.OUTPUT_PATH);
	
		DatabaseConnectionParser dcp = new DatabaseConnectionParser(dbConnPath+dbConfigFileName);
		
		Map<String,Connection> connectionMap = dcp.createConnectionMap();
		for(String sqlFileName : sqlFileNameList){
			SQLFileParser sfp = new SQLFileParser(sqlFileBasePath + sqlFileName);
			List<SqlQueryObject> queryObjList = sfp.createListOfQueries();
			
			DatabaseReader dr =  new DatabaseReader();
			Connection conn = connectionMap.get(sfp.getConnName());
			if(conn != null) {
		
			
			dr.setUpReader(conn,sfp.getConnName(), variables , queryObjList);
			dr.replaceVariables(); 
			
			sfp.printQuery();
			Map<String, ResultSet> resultSetMap = dr.executetQueryList();
			dr.executetQueryList(); 
			DataExport de = new DataExportImpl();
			String outputFileName = sqlFileName.substring(0,sqlFileName.indexOf("."));//to get file name without .sql
				de.export(outPutFilePath + outputFileName, resultSetMap);
		
		}else{
			throw new Exception("Connection Not setUp correctly");
		}
			
		}
		
		
	}
		
	
	

}


