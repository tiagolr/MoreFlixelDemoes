package ;
import org.flixel.nape.FlxPhysSprite;
import nme.Assets;
import org.flixel.FlxG;
import org.flixel.FlxSprite;
import org.flixel.FlxU;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class Orb extends FlxPhysSprite
{

	public var shadow:FlxSprite;
	
	public function new ()
	{
		super(FlxG.width / 2, FlxG.height / 2, Assets.getBitmapData("assets/Orb.png"));
		createCircularBody(18);
		body.allowRotation = false;
		setDrag(0.98, 1);
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.camera.target != null && FlxG.camera.followLead.x == 0) // target check is used for debug purposes.
		{
			x = FlxU.round(x); // Smooths camera and orb shadow following. Does not work well with camera lead.
			y = FlxU.round(y); // Smooths camera and orb shadow following. Does not work well with camera lead.
		}
		
		shadow.x = FlxU.round(x);
		shadow.y = FlxU.round(y);
	}
	
}