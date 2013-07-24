package states;
import flash.display.Sprite;
import flixel.addons.nape.FlxPhysState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxSpriteUtil;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.dynamics.InteractionFilter;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
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
	
	var shooter:Shooter;
	var listBlobCircles:Array<Body>;
	var blob:Sprite;
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.show();
		
		createWalls();
		createBlob();
		FlxPhysState.space.gravity.setxy(0, 500);
		shooter = new Shooter();
		add(shooter);
		
		FlxPhysState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, 
																 InteractionType.COLLISION, 
																 Shooter.CB_BULLET,
																 CbType.ANY_BODY,
																 onBulletColides));
																 
		blob = new Sprite();
		FlxG.stage.addChildAt(blob, 1);
		
	}
	
	override public function destroy():Void 
	{
		FlxG.stage.removeChild(blob);
		super.destroy();
	}
	
	function createBlob() 
	{
		listBlobCircles = new Array<Body>();
		
		var i:Int = 0;
		
		while (i < 360) 
		{
			var angle = FlxAngle.asRadians(i);
			var circle:Body = new Body(BodyType.DYNAMIC, new Vec2(FlxG.width / 2 + Math.cos(angle) * BLOB_RADIUS, FlxG.height / 2 + Math.sin(angle) * BLOB_RADIUS));
			circle.shapes.add(new Circle(CIRCLE_RADIUS));
			circle.space = FlxPhysState.space;
			listBlobCircles.push(circle);
			
			i += Std.int(360 / NUM_CIRCLES);
		}
		
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
	}
	
	override public function update():Void 
	{
		super.update();
		
		blob.graphics.clear();
		blob.graphics.beginFill(BLOB_COLOR, 1);
		blob.graphics.lineStyle(CIRCLE_RADIUS * 2, BLOB_COLOR, 1);
		
		var b:Body;
		b = listBlobCircles[listBlobCircles.length - 1];
		blob.graphics.moveTo(b.position.x, b.position.y);
		b = listBlobCircles[0];
		blob.graphics.lineTo(b.position.x, b.position.y);
		
		for (i in 1...listBlobCircles.length)
		{
			b = listBlobCircles[i];
			blob.graphics.lineTo(b.position.x, b.position.y);
		}
		
		blob.graphics.endFill();
		
		if (FlxG.keys.justPressed("G"))
			disablePhysDebug(); // PhysState method to remove the debug graphics.
			
		if (FlxG.keys.justPressed("LEFT")) 
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed("RIGHT"))
			FlxPhysicsDemo.nextState();
	}
	
	public function onBulletColides(clbk:InteractionCallback) 
	{
	}
}