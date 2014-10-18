package org.aggi.sqldata;

public class SqlQueryObject {
	private String name;
	private String query;
	private String [] variables;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getQuery() {
		return query;
	}
	public void setQuery(String query) {
		this.query = query;
	}
	public String [] getVariables() {
		return variables;
	}
	public void setVariables(String [] variables) {
		this.variables = variables;
	}
}
