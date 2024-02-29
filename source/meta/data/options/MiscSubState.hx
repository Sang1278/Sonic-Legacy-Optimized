package meta.data.options;

import flash.text.TextField;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import meta.data.Controls;
import meta.data.*;
import meta.states.*;
import gameObjects.*;
import openfl.Lib;

using StringTools;

class MiscSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Misc';
		rpcTitle = 'Miscellaneous Menu'; //for Discord Rich Presence
			// if you guys ever add more options to misc that dont rely on the thread count
			var option:Option = new Option("Nothin' here!", //Name
				"Usually there'd be options about multi-thread loading, but you only have 1 thread to use so no real use", //Description
				'', //Save data variable name
				'label', //Variable type
				true
			); //Default value
			addOption(option);

		var option:Option = new Option('GPU Caching',
		'If enabled, allows assets to be cached directly to the GPU. helps Performance',
		'cacheOnGPU',
		'bool',
		false
		);
		addOption(option);

		super();
	}

}
