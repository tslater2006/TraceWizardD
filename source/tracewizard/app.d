module tracewizard.app;

/* Debug */

version(unittest) {
	import std.stdio;
	int main()
	{
		writeln("Hello, World!");
		return 0;
	}
} else {
	import dlangui;
	import tracewizard.ui.tracewizardframe;
	import tracewizard.data.models;

	mixin APP_ENTRY_POINT;

	extern (C) int UIAppMain(string[] args) {
		Window window = Platform.instance.createWindow("Trace Wizard D",null,WindowFlag.Resizable,900,600);
		
		auto frame = new TraceWizardFrame(window);
		
		window.show();
	


		return Platform.instance.enterMessageLoop();
	}
}

