package ;

import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIText;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIButton;

/**
 * ...
 * @author Ciro Duran
 */
class CreditsState extends FlxState
{

	override public function create():Void
	{
		
		var bg : FlxSprite = new FlxSprite(0, 0, AssetPaths.splash_screen_temp__png);
		add(bg);
		
		var logo : FlxSprite = new FlxSprite(FlxG.width/2 - 562/2, -10, AssetPaths.logo__png);
		add(logo);
		
		var le_text : FlxText = new FlxText(FlxG.width / 2 - 300, 190, 600, "Thanks for playing \"There are no vampires here\". If you find anything that does not cater to your standards of satisfaction, please let Management know.\n\nCredits:\n\nStelios Avramidis - Stupendous Programming and Glamorous Design\nCiro Durán - Bombastic Programming\nMary Safro - Overwhelming Art\nDouglas Pennants - Explosive Sound\n\nStelios: For my parents / Ciro: For .Y. / All: For Simon Franco\nMade for the Franco Game Jam, at The Creative Assembly.\nHorsham, November 2014.", 12, true);
		add(le_text);
		
		var le_button : FlxUIButton = new FlxUIButton(FlxG.width / 2 - 250, FlxG.height - 40, "Go back and play!", go_back);
		le_button.resize(200, 30);
		le_button.label = new FlxUIText(0, 4, 200, "Go back and play!");
		le_button.label.setFormat(null, 16, 0x333333, "center");
		add(le_button);
		le_button.x = FlxG.width - le_button.width - 20;
	}
	
	public function go_back() : Void
	{
		FlxG.switchState(new MenuState());
	}
	
}