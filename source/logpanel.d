module  tracewizard.ui.logpanel;

import dlangui;

class LogPanel : DockWindow
{
	this(string id)
	{
		super(id);
		_showCloseButton = false;
		dockAlignment = DockAlignment.Bottom;
	}

	override protected Widget createBodyWidget() {

		return new LogWidget();

	}


}

