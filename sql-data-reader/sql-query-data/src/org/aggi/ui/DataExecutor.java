package org.aggi.ui;

import java.awt.Checkbox;
import java.awt.Component;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Panel;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;

import org.aggi.sqldata.Runner;
import org.aggi.sqldata.SQLFileEnumerator;
import org.aggi.sqldata.ServiceException;
import org.aggi.sqldata.impl.PropertyConfigReader;

public class DataExecutor {

	private static JFrame frame = null;
	private JButton btnSetting = null;
	private final Runner runner = new Runner();

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
					JOptionPane.showMessageDialog(frame, "Exception : " + e);
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
		frame.getContentPane().setLayout(new GridLayout(3,1));
		
		Panel sqlFilesPanelMain = new Panel();
		sqlFilesPanelMain.setLayout(new FlowLayout(FlowLayout.LEFT));
		JLabel headerLabel = new JLabel();
		headerLabel.setText("Select available sql file: ");
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
		
		final Map<String,Component> controlsMap = new HashMap<String,Component>();
		final Map<String,Checkbox> checkboxesMap = new HashMap<String,Checkbox>();
		
		try {
			final Map<String,Set<String>> variablesMap = SQLFileEnumerator.getVariablesInSQLFiles(sqlFilespath);
			final Map<String,Set<String>> fieldsMap = new HashMap<String,Set<String>>();
			
			final Panel variablesPanel = new Panel();
			variablesPanel.setLayout(new FlowLayout(FlowLayout.LEFT));
			Set<String> variables = null;
			Set<String> fields = null;
			JTextField text = null;
			JLabel label = null;
			
			for(String key:variablesMap.keySet()) {
				
				variables = variablesMap.get(key);
				for(String variable:variables) {
					
					variable = variable.replace("<", "").replace(">", "");
					if(!fieldsMap.keySet().contains(variable)) {
						
						label = new JLabel();
						label.setText(variable + ": ");
						variablesPanel.add(label);
												
						text = new JTextField();
						text.setText(variable);
						text.setEnabled(false);
						variablesPanel.add(text);
						text.setColumns(10);
						
						label.setLabelFor(text);
						
						controlsMap.put(variable, text);
						fields = new HashSet<String>();
						fieldsMap.put(variable, fields);
					}
				}
			}
			
			
			Checkbox chkSQLFile = null;
			for( String filename: filenames) {
				
				chkSQLFile = new Checkbox(filename);
				checkboxesMap.put(filename, chkSQLFile);
				
				chkSQLFile.addItemListener(new ItemListener() {
					public void itemStateChanged(ItemEvent e) {   
						
						if(e.getStateChange()==1) {
							
							String filename = ((Checkbox) e.getSource()).getLabel();
							Set<String> variables = variablesMap.get(filename);
							for(String variable:variables) {
								variable = variable.replace("<", "").replace(">", "");
								Set<String> fields=fieldsMap.get(variable);
								if(!fields.contains(filename)){
									fields.add(filename);
									Component control = controlsMap.get(variable);
									control.setEnabled(true);
								}
							}
							
						} else {
							
							String filename = ((Checkbox) e.getSource()).getLabel();
							Set<String> variables = variablesMap.get(filename);
							for(String variable:variables) {
								variable = variable.replace("<", "").replace(">", "");
								Set<String> fields=fieldsMap.get(variable);
								if(fields.remove(filename) && fields.size()<=0) {
									Component control = controlsMap.get(variable);
									control.setEnabled(false);
									if(control instanceof JTextField) {
										((JTextField) control).setText(variable);
									}
								}
							}
								 
						}
						
						variablesPanel.validate();
						variablesPanel.repaint();
					}
				});
				sqlFilesPanel.add(chkSQLFile);
			}
			sqlFilesPanelMain.add(sqlFilesPanel);	
			frame.getContentPane().add(sqlFilesPanelMain);
			
			frame.getContentPane().add(variablesPanel);
		} catch (ServiceException e1) {
			JOptionPane.showMessageDialog(frame, "Exception : " + e1);
		}
		
		
		Panel buttonsPanel = new Panel();
		buttonsPanel.setLayout(new FlowLayout(FlowLayout.RIGHT));
		
		
		JButton btnExecute = new JButton("Execute");
		btnExecute.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				
				System.out.println("Execute Action");
				Map<String,String> variables = new HashMap<String,String>();
				List<String> sqlFileNameList = new ArrayList<String>();
				
				for(String filename:checkboxesMap.keySet()) {
					Checkbox checkbox = checkboxesMap.get(filename);
					if(checkbox.getState()) {
						sqlFileNameList.add(filename);
					}					
				}
				
				for(String variable:controlsMap.keySet()) {
					Component control = controlsMap.get(variable);
					if(control instanceof JTextField) {
						variables.put("<" + variable + ">", ((JTextField) control).getText());
					}
				}
				
				try {
					frame.getContentPane().setEnabled(false);
					runner.dataExtractorRunner(sqlFileNameList, variables, "conn.txt");
				} catch (Exception e1) {
					JOptionPane.showMessageDialog(frame, "Exception : " + e1);
				}
				frame.getContentPane().setEnabled(true);
			}
		});
		buttonsPanel.add(btnExecute);
		
		btnSetting = new JButton("Setting");
		buttonsPanel.add(btnSetting);
		frame.getContentPane().add(buttonsPanel);
	}
}
