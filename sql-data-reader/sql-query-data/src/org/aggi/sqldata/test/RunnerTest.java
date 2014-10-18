package org.aggi.sqldata.test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.aggi.sqldata.DataExport;
import org.aggi.sqldata.DatabaseConn;
import org.aggi.sqldata.DatabaseReader;
import org.aggi.sqldata.SQLFileParser;
import org.aggi.sqldata.ServiceException;
import org.aggi.sqldata.SqlQueryObject;
import org.aggi.sqldata.impl.DataExportImpl;
import org.junit.Before;
import org.junit.Test;

public class RunnerTest {
	Connection conn = null;
	@Before
	public void setUp(){
		 conn = new DatabaseConn().getConnection("jdbc:oracle:thin:@EISORA001:1522:tiaa001", "AGGI2_TPA", "AGGI2_TPA_123");
	}
	@Test
	public void testEndTOEnd(){
		SQLFileParser sfp = new SQLFileParser("/stac.sql");
		
		DatabaseReader dr =  new DatabaseReader();
		List<SqlQueryObject> queryList = null;
		try {
			queryList = sfp.createListOfQueries();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String ssn = "374952166";
		dr.setUpReader(sfp.getConnName(), conn, ssn, queryList);
		sfp.printQuery();
		Map<String, ResultSet> resultSetMap = new HashMap<String,ResultSet>();
		
		try {
			resultSetMap = dr.executetQueryList();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		DataExport de = new DataExportImpl();
		try {
			de.export("test", resultSetMap);
		} catch (ServiceException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
}
