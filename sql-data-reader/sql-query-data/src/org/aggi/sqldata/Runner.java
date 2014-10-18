package org.aggi.sqldata;

public class Runner {

	public static void main(String args[])
	{
		System.out.println("Starting Data Reader");
		SQLFileParser fileParser = new SQLFileParser("mvas.txt");
		fileParser.printQuery();
	}
	
}
