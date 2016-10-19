module tracewizard.data.models;

import std.typecons;
import std.string;
import std.regex;

version(unittest) {
	import std.stdio;
}

enum DiffStatus {
	SAME, INSERT, DELETE, MODIFIED
}

enum ExecutionCallType {
	NORMAL, EXTERNAL, CALL, SQL
}

enum SQLType {
	SELECT, UPDATE, DELETE, INSERT 
}

class StatisticItem {
	public static uint NextId;
	public uint InternalID;

	public string Category;
	public string Label;
	public string Value;

	this() {
		InternalID = NextId++;
	}
}

class ExecutionCall {
	public static uint NextId;
	public uint InternalID;
	
	SQLStatement SQLStmt;
	StackTraceEntry StackTrace;
	PPCException Exception;
	ExecutionCallType Type;
	ExecutionCall Parent;
	ExecutionCall[] Children;
	
	public bool HasError;
	public bool IsError;
	public int IndentCount;
	public string Context = "";
	public string Nest = "";
	public string Function = "";
	public long StartLine;
	
	@property double Duration() {return 0.0;}
	@property Duration(double d) {
		_duration = d;
	}
	@property long StopLine() {
		return _stopLine;
	}
	@property StopLine(long line) {
		_stopLine = line;
	}
	@property InternalStopLine() {
		return _stopLine;
	}
	@property Tuple!(long,string)[] GetStackTrace() {
		
		Tuple!(long,string)[] trace;
		
		trace ~= Tuple!(long,string)(StartLine,Function);
		
		auto parent = this.Parent;
		
		while (parent !is null) {
			trace ~= Tuple!(long,string)(parent.StartLine,parent.Function);
			
			parent = parent.Parent;
		}
		
		return trace;
	}
	
private:
	double _duration;
	long _stopLine;
	
	this() {
		InternalID = NextId++;
	}
}

class SQLStatement {
	public static uint NextId;
	public uint InternalID;
	
	public long LineNumber;
	public ExecutionCall ParentCall;
	public int FetchCount;
	public string Statement;
	
	public string WhereClause;
	public string FromClause;
	public double ExecTime;
	public double FetchTime;
	
	public bool IsError;
	
	public SQLError ErrorInfo;
	
	public int RCNumber;
	public SQLBindValue[] BindValues;
	public string[] Tables;
	
	public SQLType Type;
	
	this() {
		InternalID = NextId++;
	}
	
	this(string sqlText) {
		this();
		Statement = strip(sqlText);
		DetermineType();
		ParseWhereClause();
		ParseFromClause();
	}
	
	void DetermineType() {
		if (indexOf(Statement,"SELECT",CaseSensitive.no) == 0) {
			Type = SQLType.SELECT;
		} else if (indexOf(Statement,"UPDATE",CaseSensitive.no) == 0) {
			Type = SQLType.UPDATE;
		} else if (indexOf(Statement,"DELETE",CaseSensitive.no) == 0) {
			Type = SQLType.DELETE;
		} else if (indexOf(Statement,"INSERT",CaseSensitive.no) == 0) {
			Type = SQLType.INSERT;
		}
	}
	unittest {
		SQLStatement _select = new SQLStatement("SELECT * FROM X");
		SQLStatement _update = new SQLStatement("UPDATE X SET ");
		SQLStatement _delete = new SQLStatement("DELETE FROM X");
		SQLStatement _insert = new SQLStatement("INSERT INTO  X");

		assert(_select.Type == SQLType.SELECT);
		assert(_update.Type == SQLType.UPDATE);
		assert(_delete.Type == SQLType.DELETE);
		assert(_insert.Type == SQLType.INSERT);

	}

	void ParseWhereClause() {
		auto whereClauseRegex = ctRegex!(` WHERE (.*?)(ORDER|$)`,"i");
		auto match = matchFirst(Statement,whereClauseRegex);

		if (!match.empty) {
			WhereClause = strip(match[1]);
		}
	}

	unittest {
		SQLStatement statement = new SQLStatement("SELECT * FROM B WHERE A=1");
		assert(statement.WhereClause == "A=1");
	}

	void ParseFromClause() {
		switch(Type) {
			case SQLType.SELECT:
				auto fromClause = ctRegex!("\\s+FROM\\s*(.*?)\\s*(WHERE|$)","i");
				auto match = matchFirst(Statement,fromClause);
				if (!match.empty) {
					FromClause = strip(match[1]);
				}
				break;
			case SQLType.UPDATE:
				auto fromClause = ctRegex!("UPDATE\\s*(.*?)\\s*(SET|$)","i");
				auto match = matchFirst(Statement,fromClause);
				if (!match.empty) {
					FromClause = strip(match[1]);
				}
				break;
			case SQLType.DELETE:
				auto fromClause = ctRegex!("DELETE FROM\\s*(.*?)\\s*(WHERE|$)","i");
				auto match = matchFirst(Statement,fromClause);
				if (!match.empty) {
					FromClause = strip(match[1]);
				}
				break;
			case SQLType.INSERT:
				auto fromClause = ctRegex!("INTO\\s*(.*?)\\s*(VALUES|\\(|$)","i");
				auto match = matchFirst(Statement,fromClause);
				if (!match.empty) {
					FromClause = strip(match[1]);
				}
				break;
			default:
				break;
		}
	}

	unittest {
		SQLStatement _select = new SQLStatement("SELECT * FROM X");
		SQLStatement _update = new SQLStatement("UPDATE X SET VALUES");
		SQLStatement _delete = new SQLStatement("DELETE FROM X WHERE A = 3");
		SQLStatement _insert = new SQLStatement("INSERT INTO X ()");

		assert(_select.FromClause == "X");
		assert(_update.FromClause == "X");
		assert(_delete.FromClause == "X");
		assert(_insert.FromClause == "X");
	}
}


class StackTraceEntry {
	public static uint NextId;
	public uint InternalID;
	
	public long LineNumber;
	public string Message;
	public string Offender;
	public string[] StackTrace;
	
	public ExecutionCall Parent;
	
	this() {
		InternalID = NextId++;
	}
}

class PPCException {
	public static uint NextId;
	public uint InternalID;
	
	public long LineNumber;
	public string Message;
	
	this() {
		InternalID = NextId++;
	}
}

class SQLError {
	public static uint NextId;
	public uint InternalID;
	
	public int ErrorPosition;
	public int ReturnCode;
	public string Message;
	
	this() {
		InternalID = NextId++;
	}
}

class SQLBindValue {
	public static uint NextId;
	public uint InternalID;
	
	public int Index;
	public int Type;
	public int Length;
	public string Value;
	
	this() {
		InternalID = NextId++;
	}
}