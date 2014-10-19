package org.aggi.ui;

import java.awt.Checkbox;
import java.awt.CheckboxGroup;
import java.awt.Component;
import java.awt.EventQueue;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.Label;
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
import javax.swing.JTextField;

import org.aggi.sqldata.Runner;
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
			Label label = null;
			for(String key:variablesMap.keySet()) {
				variables = variablesMap.get(key);
				for(String variable:variables) {
					variable = variable.replace("<", "").replace(">", "");
					if(!fieldsMap.keySet().contains(variable)) {
						label = new Label();
						label.setText(variable + ": ");
						if(fieldsMap.containsKey(variable)) {
							fields = fieldsMap.get(variable);
							fields.add(key);
						} else {
							fields = new HashSet<String>();
							fields.add(key);
							fieldsMap.put(variable, fields);
						}
						variablesPanel.add(label);
						text = new JTextField();
						text.setText(variable);
						((Component) text).setEnabled(false);
						//textSSN.setBounds(40, 48, 134, 28);
						variablesPanel.add(text);
						text.setColumns(10);
						controlsMap.put(variable, text);
						fields = new HashSet<String>();
						fieldsMap.put(variable, fields);
					}
				}
			}
			
			
			Checkbox chkSQLFile = null;
			//CheckboxGroup cbg = new CheckboxGroup();
			for( String filename: filenames) {
				chkSQLFile = new Checkbox(filename);
				checkboxesMap.put(filename, chkSQLFile);
				//cbg.add(chkSQLFile);
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
							//JOptionPane.showMessageDialog(null, filename, "InfoBox: ", JOptionPane.INFORMATION_MESSAGE);
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
			// TODO Auto-generated catch block
			e1.printStackTrace();
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
				new Runner().dataExtractorRunner(sqlFileNameList, variables, "conn.txt");
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
