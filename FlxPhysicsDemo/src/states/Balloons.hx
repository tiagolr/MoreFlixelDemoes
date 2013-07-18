package states;
import flixel.addons.nape.FlxPhysState;
import flixel.addons.nape.FlxPhysSprite;
import flixel.FlxG;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;

/**
 * ...
 * @author TiagoLr (~~~ ProG4mr ~~~)
 */
class Balloons extends FlxPhysState
{
	var listBalloons:Array<Balloon>;
	private var shooter:Shooter;
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.show();
		
		// Sets gravity.
		FlxPhysState.space.gravity.setxy(0, 500);

		//createWalls( -2000, 0, 1640, FlxG.height);
		createWalls();
		createBalloons();
		createBox();
		shooter = new Shooter();
		add(shooter);
		
		FlxPhysState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, 
													 InteractionType.COLLISION, 
													 Shooter.CB_BULLET,
													 CbType.ANY_BODY,
													 onBulletColides));
	}
	
	function createBalloons() 
	{
		listBalloons = new Array<Balloon>();
		for (i in 0...5)
		{
			var b:Balloon = new Balloon(Std.int(FlxG.width * 0.5 - 50 * 2.5 + 50 * i + 25), 300);
			listBalloons.push(b);
			add(b);
		}
	}
	
	function createBox() 
	{
		var box:FlxPhysSprite = new FlxPhysSprite(FlxG.width * 0.5, 400);
		box.createRectangularBody(40, 40);
		add(box);
		
		for (b in listBalloons)
		{
			var constrain:DistanceJoint = new DistanceJoint(box.body, b.body, box.body.localCOM, b.body.localCOM, 0, 200);
			constrain.space = FlxPhysState.space;
		}
		
	}
	
	override public function update():Void 
	{
		super.update();
		for (b in listBalloons)
		{
			b.body.applyImpulse(new Vec2(0, -20));
		}
	}
	
	public function onBulletColides(clbk:InteractionCallback) 
	{
		if (shooter.getFirstAlive() != null) 
		{
			shooter.getFirstAlive().kill();
		}
	}
	
}


class Balloon extends FlxPhysSprite
{
	public function new(X:Int, Y:Int)
	{
		super(X, Y);
		createCircularBody(25);
	}
}