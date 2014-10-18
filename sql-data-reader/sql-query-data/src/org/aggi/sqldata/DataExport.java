package org.aggi.sqldata;

import java.sql.ResultSet;
import java.util.Map;

public interface DataExport {

	public abstract void export(String fileName,
			Map<String, ResultSet> resultSets);

}