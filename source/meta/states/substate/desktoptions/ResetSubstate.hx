package meta.states.substate.desktoptions;

import meta.states.desktop.DesktopOptionsState;
import flixel.addons.text.FlxTypeText;
import meta.states.substate.MusicBeatSubstate;

class ResetSubstate extends MusicBeatSubstate
{

   var resetString:String = 'Warning!\nDoing this will erase data permanently from this device!\nPlease proceed with caution.';
   var text:FlxTypeText;
   var options:FlxTypeText = null;
   var deletingProgress:Bool = false;
   var clicked:Bool = false;
   var allowToGo:Bool = false;

    public function new() {
        super();

        text = new FlxTypeText(355.5, 252.15,400,resetString);
        //text.sounds = [for (i in 1...5)FlxG.sound.load(Paths.sound('keyboard/click$i'))];
        text.setFormat(Paths.font("cmd.ttf"), 16, FlxColor.WHITE, LEFT);
        add(text);
        text.start(0.025,false,false,null,spawnOptions);

        cameras = [DesktopOptionsState.instance.display];
        #if mobile
        addVirtualPad(NONE, A_B_C_X_Y);
        addVirtualPadCamera(false);
        #end
    }


    function spawnOptions() {
        options = new FlxTypeText(355.5, 252.15,366,'\n\n\n\n\nPRESS THE CORRESPONDING NUMBER TO CONTINUE.\n\nButton C: Reset Progression Data\n\nButton X: Reset Option Data \n\nButton Y: Reset all Data');
        //options.sounds = [for (i in 1...5)FlxG.sound.load(Paths.sound('keyboard/click$i'))];   
        options.setFormat(Paths.font("cmd.ttf"), 16, FlxColor.WHITE, LEFT);
        add(options);
        new FlxTimer().start(1,Void->{options.start(0.025);});
    }

    function leaveMenu() {
        DesktopOptionsState.instance.returning();
		       #if desktop
			      close();
			      #else
			      FlxG.resetState();
			      #end 
    }
    
    override function update(elapsed:Float) {
        super.update(elapsed);

        #if mobile
				if (FlxG.android.justReleased.BACK)
			  FlxG.stage.window.textInputEnabled = true;
			  #end

        if (controls.BACK) {
            leaveMenu();
        }
        if (controls.ACCEPT && allowToGo)leaveMenu();

        if (options != null) {
            if (#if desktop FlxG.keys.justPressed.ONE #else virtualPad.buttonC.justPressed #end) {
                deleteData(true);
                clicked = true;
            }
            else if (#if desktop FlxG.keys.justPressed.TWO #else virtualPad.buttonX.justPressed #end) {
                deleteData(false,true);
                clicked = true;
            }
            else if (#if desktop FlxG.keys.justPressed.THREE #else virtualPad.buttonY.justPressed #end) {
                clicked = true;
                deleteData(true,true);
            }
        }
    }

    function deleteData(deleteProgress:Bool,deleteSave:Bool = false) {

        destroyData(deleteProgress,deleteSave);


        options.visible = false;
        text.resetText('Data deletion Succesful.');
        text.start();
        text.completeCallback = ()-> {
            if (deleteProgress) {
                options.visible = true;
                options.resetText('\nSee you another time');
                options.start(0.25);
                options.completeCallback = ()-> {
                    new FlxTimer().start(1,Void->{
                        Sys.exit(0);
                    });
                }
            }
            else {
                options.resetText('\nPress A to Continue.');
                options.start();
                options.visible = true;
                allowToGo=true;
                //leaveMenu();
            }
        }
    }

    public static function destroyData(deleteProgress:Bool,deleteSave:Bool = false) 
    {
        if (deleteProgress) {
            FlxG.save.data.songsUnlocked = [];
            FlxG.save.data.isRodent = null;
            FlxG.save.data.currentlyRodent = true;
        }

        if (deleteSave) {
            for (i in Reflect.fields(ClientPrefs.defaultData)) Reflect.setField(ClientPrefs.data, i, Reflect.field(ClientPrefs.defaultData, i));
        }

        FlxG.save.flush();


    }

}