module tracewizard.ui.tracewizardframe;

import dlangui;
import std.stdio;
import std.conv;

import tracewizard.ui.logpanel;
import tracewizard.ui.execpath;
import tracewizard.ui.sqlstatements;
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

		MenuItem fileOpenItem = new MenuItem(new Action(2,"Open"d));

		MenuItem fileCompareItem = new MenuItem(new Action(3,"Compare Traces"d));

		MenuItem fileExitItem = new MenuItem(new Action(4,"Exit"d));

		fileItem.add(fileOpenItem);
		fileItem.add(fileCompareItem);
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

		//_progressBar.textColor = Color.black;
		//_progressBar.backgroundColor = Color.white;

		line.addChild(_progressBar);

		//line.backgroundColor = Color.white;

		return line;
	}

	override bool handleAction(const Action a) {
		if (a.id == 4) {
			window.close();
			return true;
		}
		return false;

	}
}

