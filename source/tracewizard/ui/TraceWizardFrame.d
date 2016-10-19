module tracewizard.ui.tracewizardframe;

import dlangui;
import dlangui.dialogs.dialog;
import dlangui.dialogs.filedlg;

import std.stdio;
import std.conv;
import core.thread;

import tracewizard.ui.logpanel;
import tracewizard.ui.execpath;
import tracewizard.ui.sqlstatements;

enum UIActions {
	FILE_OPEN, FILE_EXIT
}

class TraceWizardFrame : AppFrame
{

	MenuItem mainMenuItems;
	TabWidget _tabs;
	ExecutionPath _execPath;
	SQLStatements _sqlStatements;

	Window _parentWindow;
	ProgressBarWidget _progressBar;
	DockHost _dockHost;

	LogPanel _logPanel;

	this(Window window)
	{
		super();
		_parentWindow = window;

		layoutHeight = FILL_PARENT;
		window.mainWidget = this;

	}

	override protected Widget createBody() {

		_dockHost = new DockHost();

		_tabs = new TabWidget("TABS");
		_tabs.hiddenTabsVisibility = Visibility.Gone;
		_tabs.setStyles(STYLE_DOCK_WINDOW, STYLE_TAB_UP_DARK, STYLE_TAB_UP_BUTTON_DARK, STYLE_TAB_UP_BUTTON_DARK_TEXT, STYLE_DOCK_HOST_BODY);
		//_tabs.tabChanged = &onTabChanged;
		//_tabs.tabClose = &onTabClose;

		_execPath = new ExecutionPath("EXEC_PATH");
		_sqlStatements = new SQLStatements("SQL_STATEMENTS");

		_tabs.addTab(_execPath, "Execution Path"d, null,false);
		_tabs.addTab(_sqlStatements, "SQL Statements"d,null,false);

		_dockHost.bodyWidget = _tabs;

		_logPanel = new LogPanel("logPanel");
		_logPanel.maxHeight(200.makePointSize);
		_dockHost.addDockedWindow(_logPanel);

		return _dockHost;
	}

	override protected MainMenu createMainMenu() {

		mainMenuItems = new MenuItem();
		MenuItem fileItem = new MenuItem(new Action(1,"File"d));

		MenuItem fileOpenItem = new MenuItem(new Action(UIActions.FILE_OPEN,"Open"d));

		// MenuItem fileCompareItem = new MenuItem(new Action(3,"Compare Traces"d));

		MenuItem fileExitItem = new MenuItem(new Action(UIActions.FILE_EXIT,"Exit"d));

		fileItem.add(fileOpenItem);
		//fileItem.add(fileCompareItem);
		fileItem.add(fileExitItem);

		mainMenuItems.add(fileItem);

		return new MainMenu(mainMenuItems);
	}

	override protected StatusLine createStatusLine() {
		StatusLine line = new StatusLine();
		line.removeAllChildren();
		_progressBar = new ProgressBarWidget(null,500);
		_progressBar.id = "ProgressBar";
		_progressBar.animationInterval = 50;
		_progressBar.layoutWidth = FILL_PARENT;
		_progressBar.progress = 250;

		line.addChild(_progressBar);


		return line;
	}

	override bool handleAction(const Action a) {

		switch (a.id) {
			case UIActions.FILE_EXIT:
				window.close();
				return true;
			case UIActions.FILE_OPEN:
				FileDialog dlg = new FileDialog(UIString("Open Trace File"), window, null);
				dlg.addFilter(FileFilterEntry(UIString("Trace Files"d), "*.tracesql"));
				dlg.dialogResult = delegate(Dialog d, const Action result) {
					if (result.id == ACTION_OPEN.id) {
						string filename = result.stringParam;
						new LoadTraceThread(this,filename).start();
					}
				};
				dlg.show();
				return true;
			default:
				return false;
		}

	}

	void onFinishLoad() {
		window.showMessageBox("All Done!"d,"All Done!"d);

		version(CONSOLE_BUILD) {
			window.invalidate();
		}
	}
}

class LoadTraceThread : Thread {
	TraceWizardFrame appFrame;
	string traceFile;
	this(TraceWizardFrame frame, string filePath) {
		appFrame = frame;
		traceFile = filePath;

		super(&run);
	}
private:
	void run() {
		for (auto x = 0; x < 1000; x++) {
			appFrame._progressBar.progress = x;
			version(CONSOLE_BUILD) {
				appFrame.window.invalidate();
			}
			Thread.sleep(dur!("msecs")(10));
		}
		appFrame.onFinishLoad();
	}
}
