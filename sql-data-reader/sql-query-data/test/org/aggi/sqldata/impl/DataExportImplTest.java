package org.aggi.sqldata.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
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
		
		DatabaseConn  dbconn= new DatabaseConn();
		Connection conn = dbconn.getConnection("jdbc:oracle:thin:@EISORA001:1522:tiaa001", "AGGI2", "AGGI2_123");
		Statement stmt;
		try {
			
			Map<String, ResultSet> resultSets = new HashMap<String, ResultSet>();
			
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			ResultSet rs = stmt.executeQuery("select * from customer");			
			resultSets.put("test1", rs);
			
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_READ_ONLY);
			rs = stmt.executeQuery("select * from employer");			
			resultSets.put("test2", rs);
			
			dataExport.export("test-file", resultSets);
			  
			conn.close();
		} catch (SQLException ex) {
			// TODO Auto-generated catch block
			throw new ServiceException(ex);
		}
	}

}
