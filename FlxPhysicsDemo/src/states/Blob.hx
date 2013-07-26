package states;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flixel.addons.nape.FlxPhysSprite;
import flixel.addons.nape.FlxPhysState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.group.FlxGroup;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.WeldJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Circle;

/**
 * ...
 * @author TiagoLr (~~~ ProG4mr ~~~)
 */
class Blob extends FlxPhysState
{
	private static var CIRCLE_RADIUS = 20;
	private static var NUM_CIRCLES = 15;
	private static var BLOB_RADIUS = 50;
	private static var BLOB_COLOR = 0xFF;
	
	static var CB_IGNOREME:CbType = new CbType();
	
	var shooter:Shooter;
	var listBlobCircles:Array<Body>;
	var blob:FlxSprite; // FlxSprite that copies blob graphics.
	var leftEye:Eye;
	var rightEye:Eye;
	var startYOffset:Float = -250;
	var startXOffset:Float = 150;
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.show();
		
		createWalls(0,-500,0,0,10, new Material(1,1, 2,1,0.001));
		createBlob();
		FlxPhysState.space.gravity.setxy(0, 500);
		shooter = new Shooter();
		add(shooter);
																 
		
		
		// ~~~~ Creates static objects on the map.
		var physSpr:FlxPhysSprite = new FlxPhysSprite(FlxG.width / 2 + 20 + startXOffset, FlxG.height / 2 - 60);
		physSpr.createCircularBody(50);
		physSpr.body.setShapeFilters(new InteractionFilter(256, ~256)); 
		physSpr.body.type = BodyType.STATIC;
		add(physSpr);
		
		physSpr = new FlxPhysSprite(FlxG.width / 2 - 255 + startXOffset, FlxG.height / 2);
		physSpr.createCircularBody(40);
		physSpr.body.setShapeFilters(new InteractionFilter(256, ~256)); 
		physSpr.body.type = BodyType.STATIC;
		add(physSpr);
		
		physSpr = new FlxPhysSprite(FlxG.width / 2 - 135 + startXOffset, FlxG.height / 2 + 65);
		physSpr.createCircularBody(20);
		physSpr.body.setShapeFilters(new InteractionFilter(256, ~256)); 
		physSpr.body.type = BodyType.STATIC;
		add(physSpr);
		
		// ~~~~ end
	}
	
	override public function destroy():Void 
	{
		//FlxG.stage.removeChild(blob);
		super.destroy();
	}
	
	function createBlob() 
	{
		listBlobCircles = new Array<Body>();
		
		var i:Int = 0;
		
		// Creates the circle bodies.
		while (i < 360) 
		{
			var angle = FlxAngle.asRadians(i);
			var circle:Body = new Body(BodyType.DYNAMIC, new Vec2(FlxG.width / 2 + Math.cos(angle) * BLOB_RADIUS + startXOffset, FlxG.height / 2 + Math.sin(angle) * BLOB_RADIUS + startYOffset));
			circle.shapes.add(new Circle(CIRCLE_RADIUS));
			circle.setShapeMaterials(new Material(1, 0.1, 2, 1, 0.001));
			circle.space = FlxPhysState.space;
			listBlobCircles.push(circle);
			
			i += Std.int(360 / NUM_CIRCLES);
		}
		// Attatch the bodies using constrains.
		var b1:Body = null;
		var b2:Body = null;
		for (circle in listBlobCircles)
		{
			b2 = b1;
			b1 = circle;
			
			
			var filter = new InteractionFilter(2, ~2);
			b1.setShapeFilters(filter);
			
			if (b2 == null) 
			{
				b2 = listBlobCircles[listBlobCircles.length - 1];// first element will link to last one.
			}
			
			var median = new Vec2(b1.position.x + (b2.position.x - b1.position.x) / 2, b1.position.y + (b2.position.y - b1.position.y) / 2);
			var constrain:WeldJoint = new WeldJoint(b1, b2,
													b1.worldPointToLocal(median),
													b2.worldPointToLocal(median),
													0);
			
			//constrain.damping = 1;
			constrain.frequency = 7;
			constrain.stiff = false;
			constrain.space = FlxPhysState.space;
			
			
		}
		// Creates the display flxsprite.
		blob = new FlxSprite(0, 0);
		blob.makeGraphic(640, 480, 0x0);
		add(blob);
		// Creates the eyes.
		leftEye = new Eye();
		rightEye = new Eye();
		add(leftEye);
		add(rightEye);
	}
	
	override public function update():Void 
	{
		super.update();
		
		// Draws blob
		FlxSpriteUtil.flashGfxSprite.graphics.clear();
		FlxSpriteUtil.flashGfxSprite.graphics.beginFill(BLOB_COLOR, 1);
		FlxSpriteUtil.flashGfxSprite.graphics.lineStyle(CIRCLE_RADIUS * 2, BLOB_COLOR, 1);
		
		var b:Body;
		b = listBlobCircles[listBlobCircles.length - 1];
		FlxSpriteUtil.flashGfxSprite.graphics.moveTo(b.position.x, b.position.y);
		b = listBlobCircles[0];
		FlxSpriteUtil.flashGfxSprite.graphics.lineTo(b.position.x, b.position.y);
		
		for (i in 1...listBlobCircles.length)
		{
			b = listBlobCircles[i];
			FlxSpriteUtil.flashGfxSprite.graphics.lineTo(b.position.x, b.position.y);
		}
		
		FlxSpriteUtil.flashGfxSprite.graphics.endFill();
		//
		
		// Copies blob graphic to flxSprite.
		blob.pixels.fillRect(new Rectangle(0, 0, 640, 480), 0x0);
		FlxSpriteUtil.updateSpriteGraphic(blob);
		// ~
		
		if (FlxG.keys.justPressed("G"))
			disablePhysDebug(); // PhysState method to remove the debug graphics.
		if (FlxG.keys.justPressed("R"))
			FlxG.resetState();
		if (FlxG.keys.justPressed("LEFT")) 
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed("RIGHT"))
			FlxPhysicsDemo.nextState();
			
		
		// Positions Eyes in the middle of the blob, using the median x and y values of the blob.
		var medX:Float = 0;
		var medY:Float = 0;
		var body:Body;
		
		for (i in 1...5)
		{
			body = listBlobCircles[Std.int(i * NUM_CIRCLES / 4) - 1];
			medX += body.position.x; 
			medY += body.position.y;
		}
		
		medX /= 4;
		medY /= 4;
		
		leftEye.setPos(medX - 28, medY - 10);
		rightEye.setPos(medX + 28, medY - 10);
			
	}

}

class Eye extends FlxGroup
{
	var outerEye:FlxSprite;
	var innerEye:FlxSprite;
	
	
	var eyeRadius:Float = 15;
	var x:Float = 0;
	var y:Float = 0;
	
	public function new()
	{
		super();
		
		outerEye = new FlxSprite(0,0);
		outerEye.makeGraphic(Std.int(eyeRadius * 2), Std.int(eyeRadius * 2), 0x0, true);
		FlxSpriteUtil.drawCircle(outerEye, eyeRadius, eyeRadius, eyeRadius, 0xFFFFFF);
		outerEye.offset.x = outerEye.width / 2;
		outerEye.offset.y = outerEye.height / 2;
		add(outerEye);
		
		innerEye = new FlxSprite(0,0);
		innerEye.makeGraphic(Std.int(eyeRadius * 2), Std.int(eyeRadius * 2), 0x0, true);
		FlxSpriteUtil.drawCircle(innerEye, eyeRadius, eyeRadius, eyeRadius / 2, 0x0);
		innerEye.offset.x = outerEye.width / 2;
		innerEye.offset.y = outerEye.height / 2;
		add(innerEye);
		
		
	}
	
	public function setPos(X:Float, Y:Float)
	{
		x = X;
		y = Y;
	}
	
	override public function update()
	{
		super.update();
		
		var distance:Vec2 = new Vec2(FlxG.mouse.screenX - x, FlxG.mouse.screenY - y);
		
		outerEye.x = x;
		outerEye.y = y;
		
		//if (distance.length > eyeRadius / 2)
		distance = (distance.unit()).mul(eyeRadius / 2);
			
		innerEye.x = Math.floor(x + distance.x);
		innerEye.y = Math.floor(y + distance.y);
		
	}
}