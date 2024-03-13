package meta.states.substate.desktoptions;
import meta.states.*;
import meta.states.substate.*;
import meta.data.options.*;

class DesktopMiscSettings extends DesktopBaseOptions
{
	public function new()
	{
		var option:DesktopOption = new DesktopOption('GPU Caching',
		'If enabled, allows assets to be cached directly to the GPU. helps Performance',
		'cacheOnGPU',
		'bool',
		false
		);
		addOption(option);
		/*
		var option:Option = new Option('Persistent Cached Data',
			'If checked, images loaded will stay in memory\nuntil the game is closed, this increases memory usage,\nbut basically makes reloading times instant.',
			'imagesPersist',
			'bool',
			false);
		option.onChange = onChangePersistentData; //Persistent Cached Data changes FlxGraphic.defaultPersist
		addOption(option);
		*/

		super();
	}

}