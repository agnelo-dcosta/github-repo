package org.aggi.sqldata.impl;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import org.aggi.sqldata.DataExport;
import org.aggi.sqldata.ServiceException;

public abstract class DataExportBase implements DataExport {
	/*private void writeToFile() {
		FileOutputStream fileOut;
		try {
			//fileOut = new FileOutputStream(outputDirPath);
			wb.write(fileOut);
			fileOut.close();
		} catch (FileNotFoundException ex) {
			throw new ServiceException(ex);
		} catch (IOException ex) {
			throw new ServiceException(ex);
		}
	}*/
}
