package org.aggi.ui;

import java.awt.Checkbox;
import java.awt.Choice;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Label;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JTextField;

import org.aggi.sqldata.SQLFileEnumerator;
import org.aggi.sqldata.ServiceException;
import org.aggi.sqldata.impl.PropertyConfigReader;

public class DataExecutor {

	private JFrame frame;
	private JTextField textSSN;
	private JTextField textClientName;
	private JButton btnSetting;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					DataExecutor window = new DataExecutor();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public DataExecutor() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		Map<String,List<String>> variables = new HashMap<String,List<String>>();
		List<String> varList = new ArrayList<String>();
		varList.add("<SSN>");
		
		frame = new JFrame();
		frame.setBounds(100, 100, 695, 483);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(new GridLayout(3,1));
		
		Panel sqlFilesPanelMain = new Panel();
		sqlFilesPanelMain.setLayout(new FlowLayout(FlowLayout.LEFT));
		Label headerLabel = new Label();
		headerLabel.setText("Select available sql file: ");
		//headerLabel.setBounds(10, 10, 135, 29);
		sqlFilesPanelMain.add(headerLabel);
		
		Properties prop = null;
		try {
			prop = PropertyConfigReader.read();
		} catch (ServiceException ex) {
			// TODO Auto-generated catch block
			ex.printStackTrace();
		}
		String sqlFilespath = prop.getProperty(PropertyConfigReader.SQL_FILES_PATH);
		
		List<String> filenames = SQLFileEnumerator.listSQLFilesInFolder(sqlFilespath);
		Panel sqlFilesPanel = new Panel();
		sqlFilesPanel.setLayout(new GridLayout(filenames.size(),1));
		
		Checkbox chkApple = null;
		for( String filename: filenames) {
			chkApple = new Checkbox(filename);
			sqlFilesPanel.add(chkApple);
		}
		sqlFilesPanelMain.add(sqlFilesPanel);	
		frame.getContentPane().add(sqlFilesPanelMain);
		
		
		Panel variablesPanel = new Panel();
		variablesPanel.setLayout(new FlowLayout(FlowLayout.LEFT));
		
		textSSN = new JTextField();
		textSSN.setText("SSN");
		//textSSN.setBounds(40, 48, 134, 28);
		variablesPanel.add(textSSN);
		textSSN.setColumns(10);
		
		textClientName = new JTextField();
		textClientName.setText("Client");
		//textClientName.setBounds(40, 126, 134, 28);
		variablesPanel.add(textClientName);
		textClientName.setColumns(10);
		frame.getContentPane().add(variablesPanel);
		
		
		Panel buttonsPanel = new Panel();
		buttonsPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));
		
		
		JButton btnExecute = new JButton("Execute");
		btnExecute.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.out.println("Execute Action");
				//Runner.dataExtractorRunner(List<String> sqlFileNameList, Map<String,String> variables, String dbConfigFileName);
			}
		});
		//btnExecute.setBounds(237, 408, 206, 29);
		buttonsPanel.add(btnExecute);
		
		btnSetting = new JButton("Setting");
		//btnSetting.setBounds(553, 408, 117, 29);
		buttonsPanel.add(btnSetting);
		frame.getContentPane().add(buttonsPanel);
		
	}
}
