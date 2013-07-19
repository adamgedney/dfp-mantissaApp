package
{
	import com.adamgedney.ui.MantissaView;
	
	import flash.display.Sprite;
<<<<<<< HEAD
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
=======
>>>>>>> 3ccb1cf91ac3f7c63f6b36f4a94a502a91823e4d
	
	[SWF(width="525", height="525", frameRate="60")]
	public class Main extends Sprite
	{
		
		
		public function Main()
		{
<<<<<<< HEAD
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
=======
			//instantiates display
			var synth:MantissaView;
			synth = new MantissaView(stage);
			addChild(synth);
			//synth.scaleX = synth.scaleY = .9
			
			synth.mask = synth.mc_mask;
			
			
		}
>>>>>>> 3ccb1cf91ac3f7c63f6b36f4a94a502a91823e4d
	}
}