package org.aggi.ui;

import java.awt.Choice;
import java.awt.EventQueue;
import java.awt.Label;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import java.util.Properties;

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
		frame = new JFrame();
		frame.setBounds(100, 100, 695, 483);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.getContentPane().setLayout(null);
		
		Label headerLabel = new Label();
		headerLabel.setText("Select available sql file: ");
		headerLabel.setBounds(10, 10, 135, 29);
		frame.getContentPane().add(headerLabel);
		
		Choice sqlFileChoices = new Choice();
		sqlFileChoices.add("");
        Properties prop = null;
		try {
			prop = PropertyConfigReader.read();
		} catch (ServiceException ex) {
			// TODO Auto-generated catch block
			ex.printStackTrace();
		}
		String sqlFilespath = prop.getProperty(PropertyConfigReader.SQL_FILES_PATH);
		List<String> filenames = SQLFileEnumerator.listSQLFilesInFolder(sqlFilespath);
		for( String filename: filenames) {
			sqlFileChoices.add(filename);
		}
		sqlFileChoices.setBounds(150, 10, 206, 29);
		frame.getContentPane().add(sqlFileChoices);
		
		JButton btnExecute = new JButton("Execute");
		btnExecute.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				System.out.println("Execute Action");
			}
		});
		btnExecute.setBounds(237, 408, 206, 29);
		frame.getContentPane().add(btnExecute);
		
		textSSN = new JTextField();
		textSSN.setText("SSN");
		textSSN.setBounds(40, 48, 134, 28);
		frame.getContentPane().add(textSSN);
		textSSN.setColumns(10);
		
		textClientName = new JTextField();
		textClientName.setText("Client");
		textClientName.setBounds(40, 126, 134, 28);
		frame.getContentPane().add(textClientName);
		textClientName.setColumns(10);
		
		btnSetting = new JButton("Setting");
		btnSetting.setBounds(553, 408, 117, 29);
		frame.getContentPane().add(btnSetting);		
		
	}
}
