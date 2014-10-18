package org.aggi.sqldata.impl;

import java.io.FileOutputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.aggi.sqldata.DataExport;
import org.aggi.sqldata.ServiceException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

public class DataExportImpl implements DataExport {
	
	/* (non-Javadoc)
	 * @see org.aggi.sqldata.DataExport#export(java.lang.String, java.util.Map)
	 */
	public void export(String fileName, Map<String,ResultSet> resultSets) throws ServiceException {
		Workbook wb = new HSSFWorkbook();
		for(String sheetName:resultSets.keySet()) {
			Sheet sheet = wb.createSheet(sheetName);
			ResultSet rs = resultSets.get(sheetName);
			
			List<String> columns = extractColumns(rs);
			Row headerRow = sheet.createRow(0);
			for( String columnName:columns ) {
				Cell headerCell = headerRow.createCell(0);
				headerCell.setCellValue(columnName);
			}
			

			
			try {
				int row = 1;
				while(rs.next()) {
				    String name = rs.getString("name");
				    String address = rs.getString("address");

				    Row dataRow = sheet.createRow(row);

				    Cell dataNameCell = dataRow.createCell(0);
				    dataNameCell.setCellValue(name);

				    Cell dataAddressCell = dataRow.createCell(1);
				    dataAddressCell.setCellValue(address);

				    row = row + 1;
				}
			} catch (SQLException ex) {
				throw new ServiceException(ex);
			}
		}
	}
	
	/*public void export(ResultSet rs) throws ServiceException {
		if(null==rs) {
			throw new ServiceException("Can't export any row as the ResultSet was null");
		}
		//List<String> columns = extractColumns(rs);
		
		//Workbook wb = new HSSFWorkbook();
		//Sheet personSheet = wb.createSheet("PersonList");
		//Row headerRow = personSheet.createRow(0);
		//Cell nameHeaderCell = headerRow.createCell(0);
		//Cell addressHeaderCell = headerRow.createCell(1);

		//String sql = "select name, address from person_table";
		
		int row = 1;
		while(rs.next()) {
		    String name = resultSet.getString("name");
		    String address = resultSet.getString("address");

		    Row dataRow = personSheet.createRow(row);

		    Cell dataNameCell = dataRow.createCell(0);
		    dataNameCell.setCellValue(name);

		    Cell dataAddressCell = dataRow.createCell(1);
		    dataAddressCell.setCellValue(address);

		    row = row + 1;
		}

		String outputDirPath = "D:/PersonList.xls";
		FileOutputStream fileOut = new FileOutputStream(outputDirPath);
		wb.write(fileOut);
		fileOut.close();
	}*/
	
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
				// TODO Auto-generated catch block
				//e.printStackTrace();
				throw new ServiceException(ex);
			}
			
		}
		return columns;
	}

}
