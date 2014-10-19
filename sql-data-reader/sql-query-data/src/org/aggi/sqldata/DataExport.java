package org.aggi.sqldata;

import java.sql.ResultSet;
import java.util.Map;

public interface DataExport {

	public abstract boolean export(String fileName, Map<String, ResultSet> resultSets) throws ServiceException;

}