module tracewizard.ui.execpath;

import dlangui;
import core.thread;

class ExecutionPath : TreeWidget
{
	this(string ID)
	{
		// Constructor code
		super(ID);

		//this.maxHeight(200.pointsToPixels);
		TreeItem tree1 = this.items.newChild("group1", "Group 1"d, "document-open");
		tree1.newChild("g1_1", "Group 1 item 1"d);
		tree1.newChild("g1_2", "Group 1 item 2"d);
		tree1.newChild("g1_3", "Group 1 item 3"d);
		TreeItem tree2 = this.items.newChild("group2", "Group 2"d, "document-save");
		tree2.newChild("g2_1", "Group 2 item 1"d, "edit-copy");
		tree2.newChild("g2_2", "Group 2 item 2"d, "edit-cut");
		tree2.newChild("g2_3", "Group 2 item 3"d, "edit-paste");
		tree2.newChild("g2_4", "Group 2 item 4"d);
		TreeItem tree3 = this.items.newChild("group3", "Group 3"d);
		tree3.newChild("g3_1", "Group 3 item 1"d);
		tree3.newChild("g3_2", "Group 3 item 2"d);
		TreeItem tree32 = tree3.newChild("g3_3", "Group 3 item 3"d);
		tree3.newChild("g3_4", "Group 3 item 4"d);
		tree32.newChild("group3_2_1", "Group 3 item 2 subitem 1"d);
		tree32.newChild("group3_2_2", "Group 3 item 2 subitem 2"d);
		tree32.newChild("group3_2_3", "Group 3 item 2 subitem 3"d);
		tree32.newChild("group3_2_4", "Group 3 item 2 subitem 4"d);
		tree32.newChild("group3_2_5", "Group 3 item 2 subitem 5"d);
		tree3.newChild("g3_5", "Group 3 item 5"d);
		tree3.newChild("g3_6", "Group 3 item 6"d);

		TreeItem tree4 = this.items.newChild("group4", "Group 4"d);
		tree4.newChild("g4_1", "Group 4 item 1"d);
		tree4.newChild("g4_2", "Group 4 item 2"d);
		TreeItem tree42 = tree4.newChild("g4_4", "Group 4 item 4"d);
		tree4.newChild("g4_4", "Group 4 item 4"d);
		tree42.newChild("group4_2_1", "Group 4 item 2 subitem 1"d);
		tree42.newChild("group4_2_2", "Group 4 item 2 subitem 2"d);
		tree42.newChild("group4_2_4", "Group 4 item 2 subitem 4"d);
		tree42.newChild("group4_2_4", "Group 4 item 2 subitem 4"d);
		tree42.newChild("group4_2_5", "Group 4 item 2 subitem 5"d);
		tree4.newChild("g4_5", "Group 4 item 5"d);
		tree4.newChild("g4_6", "Group 4 item 6"d);

	}
}

