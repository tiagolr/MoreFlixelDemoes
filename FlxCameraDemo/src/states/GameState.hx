package states;
import addons.nape.FlxPhysSprite;
import addons.nape.FlxPhysState;
import nape.geom.Vec2;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxPoint;

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class GameState extends FlxPhysState
{
	private var monkeh:FlxPhysSprite;

	override public function create():Void 
	{	
		super.create();
		
		createWalls();
		
		monkeh = new FlxPhysSprite(400 - 4, 240 - 4);
		//monkeh.makeGraphic(50, 50, 0xFFFF0000);
	
		add(monkeh);
		add(new FlxPhysSprite(300, 300));
		add(new FlxPhysSprite(320, 320));
		add(new FlxPhysSprite(340, 340));
		add(new FlxPhysSprite(360, 360));
		
		monkeh.createCircularBody();
		
		//FlxPhysState.space.gravity = new Vec2(0, 100);
		
		FlxG.camera.follow(monkeh, 3);
		//FlxG.camera.zoom = 0.5;
		//FlxG.camera.focusOn(new FlxPoint(FlxG.width / 2, FlxG.height / 2));
		
		
		
		//FlxG.camera.followAdjust(10, 10);
		//FlxG.camera.follow(monkeh);
	}
	
	override public function update():Void 
	{	
		super.update();
		
		if (FlxG.keys.A)
			monkeh.mainBody.applyImpulse(new Vec2( -5, 0));
		if (FlxG.keys.S)
			monkeh.mainBody.applyImpulse(new Vec2( 0, 5));
		if (FlxG.keys.D)
			monkeh.mainBody.applyImpulse(new Vec2( 5, 0));
		if (FlxG.keys.W)
			monkeh.mainBody.applyImpulse(new Vec2( 0, -5));
			
		if (FlxG.keys.justPressed("U")) 
			FlxG.resetState();
			
		if (FlxG.keys.justPressed("I")) 
			monkeh.destroy;	
	}
	
}