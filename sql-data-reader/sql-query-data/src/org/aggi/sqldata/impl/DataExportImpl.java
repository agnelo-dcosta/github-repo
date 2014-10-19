package org.aggi.sqldata.impl;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.aggi.sqldata.DataExport;
import org.aggi.sqldata.ServiceException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class DataExportImpl implements DataExport {
	private static final String OUTPUT_FILENAME_EXT = ".xls";
	
	/* (non-Javadoc)
	 * @see org.aggi.sqldata.DataExport#export(java.lang.String, java.util.Map)
	 */
	public void export(String filePath, Map<String,ResultSet> resultSets) throws ServiceException {
		if(null==filePath) {
			throw new IllegalArgumentException("Can NOT export to a file as the filename was NULL");
		}
		
		if(null==resultSets || resultSets.size() <= 0) {
			throw new IllegalArgumentException("Can NOT export to a file as there must be at least one result set");
		}
		
		Workbook wb = new HSSFWorkbook();
		int cellNo = 0;
	 
		for(String sheetName:resultSets.keySet()) {
			Sheet sheet = wb.createSheet(sheetName);
			ResultSet rs = resultSets.get(sheetName);
			
			List<String> columns = extractColumns(rs);
			Row headerRow = sheet.createRow(0);
			cellNo = 0;
			for( String columnName:columns ) {
				Cell headerCell = headerRow.createCell(cellNo++);
				headerCell.setCellValue(columnName);
			}
		
			try {
				int row = 1;
				while(rs.next()) {
					Row dataRow = sheet.createRow(row++);
				    
					ResultSetMetaData rsmd = rs.getMetaData();
					int columnCount = rsmd.getColumnCount();
					cellNo = 0;
					// The column count starts from 1
					for (int i = 1; i < columnCount + 1; i++ ) {
						String columnName = rsmd.getColumnName(i);
						
						Cell dataCell = dataRow.createCell(cellNo++);
						switch(rsmd.getColumnType(i)) {
							case Types.NUMERIC:
								dataCell.setCellValue(null!=rs.getBigDecimal(columnName)?rs.getBigDecimal(columnName).toString():null);
								break;
							case Types.INTEGER:
								dataCell.setCellValue(rs.getInt(columnName));
								break;
							case Types.DATE:
								dataCell.setCellValue(rs.getDate(columnName));
								break;
							case Types.TIMESTAMP:
							default:
								dataCell.setCellValue(rs.getString(columnName));
						}
					}
				}
			} catch (SQLException ex) {
				throw new ServiceException(ex);
			}
		}
	
		String outputDirPath =  filePath + OUTPUT_FILENAME_EXT;
		FileOutputStream fileOut = null;
		try {
			fileOut = new FileOutputStream(outputDirPath);
			wb.write(fileOut);
			fileOut.close();
		} catch (FileNotFoundException ex) {
			throw new ServiceException(ex);
		} catch (IOException ex) {
			throw new ServiceException(ex);
		}
	}
	
	public List<String> extractColumns(ResultSet rs) throws ServiceException {
		List<String> columns = new ArrayList<String>();
		
		if(null!=rs) {
			ResultSetMetaData rsmd;
			try {
				rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
			
				// The column count starts from 1
				for (int i = 1; i < columnCount + 1; i++ ) {
					String name = rsmd.getColumnName(i);
					columns.add(name);
				}
			} catch (SQLException ex) {
				throw new ServiceException(ex);
			}			
		}
			return columns;
	}
}
