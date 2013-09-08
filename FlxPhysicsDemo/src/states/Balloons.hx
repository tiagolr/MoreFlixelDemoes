package states;
import flash.display.Graphics;
import flash.geom.Rectangle;
import flixel.addons.nape.FlxNapeState;
import flixel.addons.nape.FlxNapeSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.DistanceJoint;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
import nape.shape.Shape;

/**
 * ...
 * @author TiagoLr (~~~ ProG4mr ~~~)
 */
class Balloons extends FlxNapeState
{
	private inline static var WIRE_MAX_LENGTH = 200;
	private inline static var NUM_BALLOONS = 7;
	public static var CB_BALLOON:CbType = new CbType();
	
	
	var listBalloons:Array<Balloon>;
	private var shooter:Shooter;
	var wiresSprite:FlxSprite; // Sprite that shows the wires graphics.
	var wires:Array<DistanceJoint>;
	var box:FlxNapeSprite;
	
	
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.show();
		
		// Sets gravity.
		FlxNapeState.space.gravity.setxy(0, 500);

		createWalls();
		createBalloons();
		createBox();
		createWires();
		
		shooter = new Shooter();
		shooter.setDensity(0.3);
		add(shooter);
		
		FlxNapeState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, 
													 InteractionType.COLLISION, 
													 Shooter.CB_BULLET,
													 Balloons.CB_BALLOON,
													 onBulletColides));
													 
		shooter.registerPhysSprite(box);
		
		for (b in listBalloons)
			shooter.registerPhysSprite(b);
	
	}
	
	function onBulletColides(i:InteractionCallback) 
	{
		var b:Balloon = cast(i.int2, Body).userData.data;
		b.onCollide();
		listBalloons.remove(b);
	}
	
	function createBalloons() 
	{
		listBalloons = new Array<Balloon>();
		for (i in 0...NUM_BALLOONS)
		{
			var b:Balloon = new Balloon(Std.int(FlxG.width * 0.5 - 50 * 2.5 + 50 * i - 25), 300);
			listBalloons.push(b);
			add(b);
		}
	}
	
	function createBox() 
	{
		box = new FlxNapeSprite(FlxG.width * 0.5, 400);
		box.createRectangularBody(40, 40);
		add(box);
	}
	
	// Wires are distance joints between balloons and box.
	function createWires()
	{
		wires = new Array<DistanceJoint>();
		for (b in listBalloons)
		{
			
			var yOffsetBox:Vec2 = new Vec2(0, -20);
			var yOffsetB:Vec2 = new Vec2(0, 25);
		
			var constrain:DistanceJoint = new DistanceJoint(box.body, b.body, yOffsetBox.add(box.body.localCOM), yOffsetB.add(b.body.localCOM), 0, WIRE_MAX_LENGTH);
			constrain.space = FlxNapeState.space;
			constrain.stiff = false;
			constrain.frequency = 5;
			wires.push(constrain);
		}
		
		wiresSprite = new FlxSprite();
		wiresSprite.makeGraphic(640, 480, 0x0);
		add(wiresSprite);
	}
	
	override public function update():Void 
	{
		super.update();
		
		for (b in listBalloons)
		{
			b.body.applyImpulse(new Vec2(0, -25));
		}
		
		// Draw wires using bezier curves.
		var gfx:Graphics = FlxSpriteUtil.flashGfxSprite.graphics;
		gfx.clear();
		gfx.lineStyle(1, 0xFFFFFF);
		
		for (wire in wires)
		{
			
			var boxAngle:Float = wire.body1.rotation + 90 * FlxAngle.TO_RAD;			
			var balloonAngle:Float = wire.body2.rotation + 90 * FlxAngle.TO_RAD;
			
			// Real position of the box and ballon where the join is attached.
			var posBox:Vec2 = new Vec2(wire.body1.position.x + wire.anchor1.y * Math.cos(boxAngle), wire.body1.position.y + wire.anchor1.y * Math.sin(boxAngle));
			var posBalloon:Vec2 = new Vec2(wire.body2.position.x + wire.anchor2.y * Math.cos(balloonAngle), wire.body2.position.y + wire.anchor2.y * Math.sin(balloonAngle));
			
			var medX = (posBox.x + posBalloon.x) / 2;			// X and Y Median points.
			var medY = (posBox.y + posBalloon.y) / 2;			// X and Y Median points.
			
			// yOffset represents how much the bezier curve control point is pulled downward simulating gravity.
			var yOffset = WIRE_MAX_LENGTH - Vec2.distance(posBox, posBalloon);		
			
			if (yOffset < 0) 
				yOffset = 0;
		
			// Caps the control point max y.
			if (posBalloon.y + yOffset > 480 + 20) 		
				yOffset = 480 + 20 - posBalloon.y; 	
				
			
				
			// Draws the curve
			gfx.moveTo(posBox.x, posBox.y);
			gfx.curveTo(medX, medY + yOffset, posBalloon.x, posBalloon.y);
			
			// Control point debug graphics:
			//gfx.lineStyle(1, 0xFF0000);
			//gfx.lineTo(medX, medY + yOffset);
			
		}
		//~
		
		// Copies generated graphics to flxSprite.
		wiresSprite.pixels.fillRect(new Rectangle(0, 0, 640, 480), 0x0);
		FlxSpriteUtil.updateSpriteGraphic(wiresSprite);
		//~
		
		// Input handling
		if (FlxG.keys.justPressed.G)
			if (_physDbgSpr != null)
				napeDebugEnabled = !napeDebugEnabled;
			
		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
			
		if (FlxG.keys.justPressed.LEFT)
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed.RIGHT)
			FlxPhysicsDemo.nextState();
			
		if (FlxG.keys.pressed.W)
			box.body.position.y -= 10;
		if (FlxG.keys.pressed.A)
			box.body.position.x -= 10;
		if (FlxG.keys.pressed.S)
			box.body.position.y += 10;
		if (FlxG.keys.pressed.D)
			box.body.position.x += 10;
		// end 
	}
	
}


class Balloon extends FlxNapeSprite
{
	public function new(X:Int, Y:Int)
	{
		super(X, Y);
		createCircularBody(25);
		var circle = new Circle(5);
		circle.translate(new Vec2(0, 25));
		circle.material = new Material(0.2, 1.0, 1.4, 0.1, 0.01);
		circle.filter.collisionGroup = 256;
		
		body.shapes.add(circle);
		body.cbTypes.add(Balloons.CB_BALLOON);
		body.userData.data = this;
		
		body.shapes.at(0).material.density = .5;
		body.shapes.at(0).material.dynamicFriction = 0;
		

	}
	
	public function onCollide() 
	{
		body.shapes.pop();
	}
}