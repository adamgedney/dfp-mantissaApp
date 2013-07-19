package
{
	import com.adamgedney.ui.MantissaView;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	[SWF(width="525", height="525", frameRate="60")]
	public class Main extends Sprite
	{
		
		
		public function Main()
		{
			//instantiates display 
			var synth:MantissaView;
			synth = new MantissaView(stage);
			addChild(synth);
			
			synth.mask = synth.mc_mask;
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var copy:ContextMenuItem = new ContextMenuItem("Copyright ©2013 Adam Gedney", true);
			copy.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, copyrightClick);
			cm.customItems.push(copy);
			this.contextMenu = cm;
			
		}
		
		private function copyrightClick(event:ContextMenuEvent):void
		{
			var ur:URLRequest = new URLRequest("http://adamgedney.com");
			navigateToURL(ur, "_blank");
			
		}
	}
}