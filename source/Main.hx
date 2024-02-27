package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.util.FlxColor;
import lime.utils.Assets as LimeAssets;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.StageScaleMode;
import meta.states.*;
import meta.data.*;
import meta.MacroData;
import meta.backend.FPSCounter;
#if sys
import sys.FileSystem;
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = InitState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPSCounter;
	public static var compilationInformation:TextField;

	// You can pretty much ignore everything from here on - your code should go in your states.

	static final videos:Array<String> = [
		"cutscene-1",
		"cutscene",
		"deterrence",
		"fire",
		"fucking burning in hell",
		"intro",
		"kinofuge",
		"lobotomy",
		"makeaGif",
		"paige",
		"run",
		"spongebob",
		"towthecrimes",
	];

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

   #if mobile
   Generic.initCrashHandler();
   #end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	public static function setScaleMode(scale:String){
		switch(scale){
			default:
				Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
			case 'EXACT_FIT':
				Lib.current.stage.scaleMode = StageScaleMode.EXACT_FIT;
			case 'NO_BORDER':
				Lib.current.stage.scaleMode = StageScaleMode.NO_BORDER;
			case 'SHOW_ALL':
				Lib.current.stage.scaleMode = StageScaleMode.SHOW_ALL;
		}
	}

	private function setupGame():Void
	{

		#if mobile
		Generic.mode = ROOTDATA;

		Sys.setCwd(haxe.io.Path.addTrailingSlash(Generic.returnPath()));

		if (!FileSystem.exists('assets')) {
			FileSystem.createDirectory('assets');
		}

		if (!FileSystem.exists('assets/videos')) {
			FileSystem.createDirectory('assets/videos');
		}

		for (file in LimeAssets.list().filter(folder -> folder.startsWith('assets/videos'))){
			if(file.endsWith(".mp4")) Generic.copyContent(file, file, true);
		}
		#end

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		// //#if !debug
		// initialState = TitleState;
		// //#end


		ClientPrefs.loadDefaultKeys();
		#if desktop
		addChild(new FNFGame(gameWidth, gameHeight, initialState, #if(flixel < "5.0.0")zoom,#end framerate, framerate, skipSplash, startFullscreen));
		#else
  	addChild(new FNFGame(1280, 720, InitState, 60, 60, true, false));
  	#end

		fpsVar = new FPSCounter(10, 3, 0xFFFFFF);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.data.showFPS;
		}
	}

	public static function resetSpriteCache(sprite:Sprite):Void
	{
		@:privateAccess {
			sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}
}

class FNFGame extends FlxGame
{private static function crashGame() {
	null
	.draw();
}

/**
* Used to instantiate the guts of the flixel game object once we have a valid reference to the root.
*/
override function create(_):Void {
	try
		super.create(_)
	catch (e)
		onCrash(e);
}

override function onFocus(_):Void {
	try
		super.onFocus(_)
	catch (e)
		onCrash(e);
}

override function onFocusLost(_):Void {
	try
		super.onFocusLost(_)
	catch (e)
		onCrash(e);
}

/**
* Handles the `onEnterFrame` call and figures out how many updates and draw calls to do.
*/
override function onEnterFrame(_):Void {
	try
		super.onEnterFrame(_)
	catch (e)
		onCrash(e);
}

/**
* This function is called by `step()` and updates the actual game state.
* May be called multiple times per "frame" or draw call.
*/
override function update():Void {
	#if CRASH_TEST
	if (FlxG.keys.justPressed.F9)
		crashGame();
	#end
	try
		super.update()
	catch (e)
		onCrash(e);
}

/**
* Goes through the game state and draws all the game objects and special effects.
*/
override function draw():Void {
	try
		super.draw()
	catch (e)
		onCrash(e);
}

private final function onCrash(e:haxe.Exception):Void {
	#if !debug
	var emsg:String = "";
	for (stackItem in haxe.CallStack.exceptionStack(true)) {
		switch (stackItem) {
			case FilePos(s, file, line, column):
				emsg += file + " (line " + line + ")\n";
			default:
				Sys.println(stackItem);
				trace(stackItem);
		}
	}

	FlxG.switchState(new meta.states.substate.CrashReportSubstate(FlxG.state, emsg, e.message));
	#end
}
}