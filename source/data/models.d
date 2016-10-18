module tracewizard.data.models;

import std.typecons;

enum DiffStatus {
	SAME, INSERT, DELETE, MODIFIED
}

enum ExecutionCallType {
	NORMAL, EXTERNAL, CALL, SQL
}

enum SQLType {
	SELECT, UPDATE, DELETE, INSERT 
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
	public string SQLID;
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