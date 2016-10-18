import dlangui;
import tracewizard.ui.tracewizardframe;
mixin APP_ENTRY_POINT;

extern (C) int UIAppMain(string[] args) {
	Window window = Platform.instance.createWindow("Trace Wizard D",null,WindowFlag.Resizable,1000,1000);

	TraceWizardFrame frame = new TraceWizardFrame(window);

	window.show();

	return Platform.instance.enterMessageLoop();
}
