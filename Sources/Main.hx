package;

import kha.System;
import kha.Assets;
import kha.Scheduler;
import echoes.Workflow;
import components.*;
import sprawl.AssetRepo;
import kha.Window;
import kha.WindowMode;

class Main 
{
	public static var WIDTH = 480;
	public static var HEIGHT = 270;
	public static var PLAYAREAHEIGHT = 230;
	public static function main() {
		System.start({
			title:"Git Gold",
			width:WIDTH,
			height:HEIGHT
		},
		function(_){
			Assets.loadEverything(function()
			{	
				AssetRepo.init();
				new Project();
			});
		});
	}
}
