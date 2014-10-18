package org.aggi.sqldata.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import org.aggi.sqldata.DataExport;
import org.aggi.sqldata.DatabaseConn;
import org.aggi.sqldata.ServiceException;
import org.junit.Test;

public class DataExportImplTest {
	
	private DataExport dataExport;
	
	@Test
	public void testExport() throws ServiceException {
		dataExport = new DataExportImpl();
		
		try {
			DatabaseConn  dbconn= new DatabaseConn();
			Connection conn = dbconn.getConnection("jdbc:oracle:thin:@EISORA001:1522:tiaa001", "AGGI2", "AGGI2_123");
			Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			 
			ResultSet rs = stmt.executeQuery("select * from customer");
			Map<String, ResultSet> resultSets = new HashMap<String, ResultSet>();
			resultSets.put("test1", rs);
			dataExport.export("test-file", resultSets);
			  
			conn.close();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

}
