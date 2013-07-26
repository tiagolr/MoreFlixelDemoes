package states;
import flixel.addons.nape.FlxPhysSprite;
import flixel.addons.nape.FlxPhysState;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.plugin.MouseEventManager;
import flixel.util.FlxPoint;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import flixel.addons.nape.FlxPhysSprite;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;
import nape.callbacks.PreListener;
import nape.constraint.DistanceJoint;
import nape.constraint.PivotJoint;
import nape.constraint.WeldJoint;
import nape.dynamics.InteractionFilter;
import nape.dynamics.InteractionGroup;
import nape.geom.Vec2;

/**
 * ...
 * @author TiagoLr (~~~ ProG4mr ~~~)
 */
class Fight extends FlxPhysState
{
	public var grabJoint:DistanceJoint;
	var shooter:Shooter;
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.show();
		
		createWalls(0,-300,FlxG.width, FlxG.height - 30);
		FlxPhysState.space.gravity.setxy(0, 400);
		
		disablePhysDebug();
		
		add(new FlxSprite(0, 0, "assets/dbzbg.jpg"));
		
		//shooter = new Shooter();
		//add(shooter);
		
		var songoku:Ragdoll = new Ragdoll(100,250);
		songoku.init();
		songoku.createGraphics("assets/GokuHead.png",
								"assets/GokuUTorso.png",
								"assets/GokuLTorso.png",
								"assets/GokuUArm.png",
								"assets/GokuLArm.png",
								"assets/GokuULeg.png",
								"assets/GokuLLeg.png");
		add(songoku);
		
		
		
		var vegeta:Ragdoll = new Ragdoll(550, 250);
		vegeta.init();
		vegeta.createGraphics("assets/VegeHead.png",
								"assets/VegeUTorso.png",
								"assets/VegeLTorso.png",
								"assets/VegeUArm.png",
								"assets/VegeLArm.png",
								"assets/VegeULeg.png",
								"assets/VegeLLeg.png");
		add(vegeta);
		
		for (spr in songoku.sprites)
		{
			spr.antialiasing = true;
			MouseEventManager.addSprite(spr, onMouseDownSprite);
		}
		for (spr in vegeta.sprites)
		{
			spr.antialiasing = true;
		}
		
		songoku.rLArm.body.applyImpulse(new Vec2(2000, -3000 + Math.random() * -100 + 200));
		//songoku.rUArm.body.applyImpulse(new Vec2(1500, -2000));
		vegeta.lLArm.body.applyImpulse(new Vec2(-2000, -3000+ Math.random() * -100 + 200));
		//vegeta.lUArm.body.applyImpulse(new Vec2(-1500, -2000));
													 
	}
	
	function onMouseDownSprite(spr:FlxSprite) 
	{
		var spr2 : FlxPhysSprite = cast(spr, FlxPhysSprite);
		grabJoint = new DistanceJoint(spr2.body, FlxPhysState.space.world, spr2.body.localCOM, new Vec2(FlxG.mouse.x, FlxG.mouse.y), 0, 10);
		grabJoint.space = FlxPhysState.space;
		
		grabJoint.stiff = false;
		grabJoint.damping = 1;
		grabJoint.frequency = 20;
	}
	
	override public function update():Void 
	{	
		super.update();
		
		if (FlxG.keys.justPressed("G"))
			if (_physDbgSpr != null)
				disablePhysDebug(); // PhysState method to remove the debug graphics.
			else
				enablePhysDebug();
			
		if (FlxG.keys.justPressed("R"))
			FlxG.resetState();
			
		if (FlxG.keys.justPressed("LEFT"))
			FlxPhysicsDemo.prevState();
		if (FlxG.keys.justPressed("RIGHT"))
			FlxPhysicsDemo.nextState();
			
		if (grabJoint != null)
		{
			grabJoint.anchor2 = new Vec2(FlxG.mouse.x, FlxG.mouse.y);
		}
		if (FlxG.mouse.justReleased())
		{
			if (grabJoint == null)
				return;
			grabJoint.space = null;
			grabJoint = null;
		}
	}
	
}


class Ragdoll extends FlxGroup 
{
	public var sprites:Array<FlxPhysSprite>;
	
	public var rULeg:FlxPhysSprite; // right upper leg.
	public var rLLeg:FlxPhysSprite; // right lower leg.
	public var lULeg:FlxPhysSprite; // left upper leg.
	public var lLLeg:FlxPhysSprite; // left lower leg.
	
	public var rUArm:FlxPhysSprite; // right upper arm.
	public var rLArm:FlxPhysSprite; // right lower arm.
	public var lUArm:FlxPhysSprite; // left upper arm.
	public var lLArm:FlxPhysSprite; // left lower arm.
	
	public var head:FlxPhysSprite; // head.
	
	public var lTorso:FlxPhysSprite; // lower torso.
	public var uTorso:FlxPhysSprite; // upper torso.
	
	public var scale:Float;
	
	public var joints:Array<PivotJoint>;
	
	public var larmSize:FlxPoint;
	public var uarmSize:FlxPoint;
	public var llegSize:FlxPoint;
	public var ulegSize:FlxPoint;
	public var uTorsoSize:FlxPoint;
	public var lTorsoSize:FlxPoint; 
	public var neckHeight:Float;
	public var headRadius:Float;
	
	public var limbOffset:Float;
	public var torsoOffset:Float;
	
	var startX:Float;
	var startY:Float;
	
	/**
	 * Creates the ragdoll
	 * @param	scale	The ragdol size scale factor.
	 */
	public function new(X:Float, Y:Float, Scale:Float = 1)
	{
		super();
		
		Scale > 0 ? scale = Scale : scale = 1;
		
		//
		larmSize = new FlxPoint(12 * scale, 45 * scale);
		uarmSize = new FlxPoint(12 * scale, 40 * scale);
		llegSize = new FlxPoint(15 * scale, 45 * scale);
		ulegSize = new FlxPoint(15 * scale, 50 * scale);
		uTorsoSize = new FlxPoint(35 * scale, 35 * scale);
		lTorsoSize = new FlxPoint(35 * scale, 15 * scale);
		neckHeight = 5 * scale;
		headRadius = 15 * scale;
		
		limbOffset = 3 * scale;
		torsoOffset = 5 * scale;
		
		startX = X;
		startY = Y;
		
	}
	
	public function init()
	{
		sprites = new Array<FlxPhysSprite>();
		
		uTorso = new FlxPhysSprite(startX, startY); sprites.push(uTorso); 
		lTorso = new FlxPhysSprite(startX, startY + 30); sprites.push(lTorso);
		
		rULeg = new FlxPhysSprite(startX + 20, startY + 100); sprites.push(rULeg);
		rLLeg = new FlxPhysSprite(startX + 20, startY + 150); sprites.push(rLLeg);
		lULeg = new FlxPhysSprite(startX - 20, startY + 100); sprites.push(lULeg);
		lLLeg = new FlxPhysSprite(startX - 20, startY + 150); sprites.push(lLLeg);
		
		rUArm = new FlxPhysSprite(startX + 20, startY); sprites.push(rUArm);
		rLArm = new FlxPhysSprite(startX + 20, startY); sprites.push(rLArm);
		lUArm = new FlxPhysSprite(startX - 20, startY); sprites.push(lUArm);
		lLArm = new FlxPhysSprite(startX - 20, startY); sprites.push(lLArm);
		
		head = new FlxPhysSprite(startX, startY - 40); sprites.push(head);
		
		add(rLLeg);
		add(lLLeg);
		add(rULeg);
		add(lULeg);
		add(rLArm);
		add(lLArm);
		add(rUArm);
		add(lUArm);
		add(lTorso);
		add(uTorso);
		add(head);
		
		createBodies();
		createContactListeners();
		createJoints();
		
		//setPos(startX, startY);
	}
	
	function setPos(x:Float, y:Float)
	{
		for (s in sprites)
		{
			s.body.position.x = x;
			s.body.position.y = y;
		}
	}
	
	function createBodies() 
	{
		rULeg.createRectangularBody(ulegSize.x, ulegSize.y);
		rLLeg.createRectangularBody(llegSize.x, llegSize.y);
		
		lULeg.createRectangularBody(ulegSize.x, ulegSize.y);
		lLLeg.createRectangularBody(llegSize.x, llegSize.y);
		
		lUArm.createRectangularBody(uarmSize.x, uarmSize.y);
		lLArm.createRectangularBody(larmSize.x, larmSize.y);
		
		rUArm.createRectangularBody(uarmSize.x, uarmSize.y);
		rLArm.createRectangularBody(larmSize.x, larmSize.y);
		
		uTorso.createRectangularBody(uTorsoSize.x, uTorsoSize.y);
		lTorso.createRectangularBody(lTorsoSize.x, lTorsoSize.y);
		
		head.createCircularBody(headRadius);
	}
	
	function createContactListeners()
	{
		// group 1 - lower left leg ignores upper left leg 
		// group 2 - lower right leg ignores upper right leg
		// group 3 - upper left legs ignores lower torso 
		// group 4 - upper rigth legs ignores lower torso 
		// group 5 - lower torso
		// group 6 - upper torso ignores upper arms 
		// group 7 - upper arms ignores lower arms | upper torso | lower torso
		// group 8 - lower arms
		
		var group1:CbType = new CbType();
		var group2:CbType = new CbType();
		var group3:CbType = new CbType();
		var group4:CbType = new CbType();
		var group5:CbType = new CbType();
		var group6:CbType = new CbType();
		var group7:CbType = new CbType();
		var group8:CbType = new CbType();
		var group9:CbType = new CbType();
		var group10:CbType = new CbType();
		
		lLLeg.body.cbTypes.add(group1);
		rLLeg.body.cbTypes.add(group2);
		lULeg.body.cbTypes.add(group3);
		rULeg.body.cbTypes.add(group4);
		lTorso.body.cbTypes.add(group5);
		uTorso.body.cbTypes.add(group6);
		lUArm.body.cbTypes.add(group7);
		rUArm.body.cbTypes.add(group7);
		lLArm.body.cbTypes.add(group8);
		rLArm.body.cbTypes.add(group8);
		head.body.cbTypes.add(group9);
		
		
		var listener;
		// lower left leg ignores upper left leg 
		listener = new PreListener(InteractionType.COLLISION, group1, group3, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;
		// lower right leg ignores upper right leg
		listener = new PreListener(InteractionType.COLLISION, group2, group4, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;
		// upper left legs ignores lower torso 
		listener = new PreListener(InteractionType.COLLISION, group3, group5, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;
		// upper rigth legs ignores lower torso 
		listener = new PreListener(InteractionType.COLLISION, group4, group5, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;
		// upper torso ignores upper arms 
		listener = new PreListener(InteractionType.COLLISION, group6, group7, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;
		// upper arms ignores lower arms | upper torso | lower torso
		listener = new PreListener(InteractionType.COLLISION, group7, group8, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;
		listener = new PreListener(InteractionType.COLLISION, group7, group6, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;
		listener = new PreListener(InteractionType.COLLISION, group7, group5, ignoreCollision, 0, true);
		listener.space = FlxPhysState.space;

	}
	
	function ignoreCollision(cb:PreCallback):PreFlag {
		return PreFlag.IGNORE;
	}
	
	public function createGraphics(Head:String, UpperTorso:String, LowerTorso:String, UpperArm:String, LowerArm:String, UpperLeg:String, LowerLeg:String)
	{
		head.loadGraphic(Head);
		uTorso.loadGraphic(UpperTorso);
		lTorso.loadGraphic(LowerTorso);
		
		rULeg.loadGraphic(UpperLeg);
		lULeg.loadGraphic(UpperLeg); lULeg.scale.x *= -1;
		rLLeg.loadGraphic(LowerLeg);
		lLLeg.loadGraphic(LowerLeg); lLLeg.scale.x *= -1;
		
		rUArm.loadGraphic(UpperArm);
		lUArm.loadGraphic(UpperArm); lUArm.scale.x *= -1;
		rLArm.loadGraphic(LowerArm);
		lLArm.loadGraphic(LowerArm); lLArm.scale.x *= -1;
	}
	
	
	function createJoints() 
	{
		var constrain: PivotJoint;
		var weldJoint: WeldJoint;
		
		// lower legs with upper legs.
		constrain = new PivotJoint(lLLeg.body, lULeg.body, new Vec2(0, -llegSize.y / 2 + 3), new Vec2(0, ulegSize.y / 2 - 3));
		constrain.space = FlxPhysState.space;
		constrain = new PivotJoint(rLLeg.body, rULeg.body, new Vec2(0, -llegSize.y / 2 + 3), new Vec2(0, ulegSize.y / 2 - 3));
		constrain.space = FlxPhysState.space;
		
		// Lower Arms with upper arms.
		constrain = new PivotJoint(lLArm.body, lUArm.body, new Vec2(0, -larmSize.y / 2 + 3), new Vec2(0, uarmSize.y / 2 - 3));
		constrain.space = FlxPhysState.space;
		constrain = new PivotJoint(rLArm.body, rUArm.body, new Vec2(0, -larmSize.y / 2 + 3), new Vec2(0, uarmSize.y / 2 - 3));
		constrain.space = FlxPhysState.space;
		
		// Upper legs with lower torso.
		constrain = new PivotJoint(lULeg.body, lTorso.body, new Vec2(0, -ulegSize.y / 2 + 3), new Vec2(-lTorsoSize.x / 2  + ulegSize.x / 2, lTorsoSize.y / 2 - 6));
		constrain.space = FlxPhysState.space;
		constrain = new PivotJoint(rULeg.body, lTorso.body, new Vec2(0, -ulegSize.y / 2 + 3), new Vec2(lTorsoSize.x / 2  - ulegSize.x / 2, lTorsoSize.y / 2 - 6));
		constrain.space = FlxPhysState.space;
		
		// Upper torso with mid lower.
		constrain = new PivotJoint(uTorso.body, lTorso.body, new Vec2(0, uTorsoSize.y / 2 + torsoOffset), new Vec2(0, -lTorsoSize.y / 2 - torsoOffset));
		constrain.space = FlxPhysState.space;
		
		// Upper arms with Upper torso.
		constrain = new PivotJoint(lUArm.body, uTorso.body, new Vec2(uarmSize.x / 2 - 3, -uarmSize.y / 2 + 3), new Vec2(-uTorsoSize.x / 2 + 3, -uTorsoSize.y / 2 + 3));
		constrain.space = FlxPhysState.space;
		constrain = new PivotJoint(rUArm.body, uTorso.body, new Vec2(-uarmSize.x / 2 + 3, -uarmSize.y / 2 + 3), new Vec2(uTorsoSize.x / 2 - 3, -uTorsoSize.y / 2 + 3));
		constrain.space = FlxPhysState.space;
		
		// Neck with upper torso.
		constrain = new PivotJoint(uTorso.body, head.body, new Vec2(0, -uTorsoSize.y / 2 - neckHeight), new Vec2(0, headRadius));
		constrain.space = FlxPhysState.space;
	}

}