module tracewizard.data.models;

import std.typecons;

class ExecutionCall {
	public static uint NextId;

	// SQLStatement
	// StackTraceEntry
	// PPCException
	// Call Type
	ExecutionCall Parent;
	ExecutionCall[] Children;

	public uint InternalID;
	public bool HasError;
	public bool IsError;
	public int IndentCount;
	public string Context = "";
	public string Nest = "";
	public string Funcntion = "";

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

	private:
	double _duration;
	long _stopLine;

	this() {
		InternalID = NextId++;
	}
}