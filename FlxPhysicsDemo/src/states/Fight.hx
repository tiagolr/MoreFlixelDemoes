package states;
import flixel.addons.nape.FlxPhysSprite;
import flixel.addons.nape.FlxPhysState;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import flixel.addons.nape.FlxPhysSprite;
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
	var shooter:Shooter;
	
	override public function create():Void 
	{
		super.create();
		FlxG.mouse.show();
		
		createWalls();
		createSongoku();
		//FlxPhysState.space.gravity.setxy(0, 100);
		
		
		shooter = new Shooter();
		add(shooter);
		
		var songoku:Ragdoll = new Ragdoll(300,300);
		songoku.init();
		add(songoku);
		
		FlxPhysState.space.listeners.add(new InteractionListener(CbEvent.BEGIN, 
													 InteractionType.COLLISION, 
													 Shooter.CB_BULLET,
													 CbType.ANY_BODY,
													 onBulletColides));
													 
	}
	
	function createSongoku() 
	{
		
	}
	
	public function onBulletColides(clbk:InteractionCallback) 
	{
		if (shooter.getFirstAlive() != null) 
		{
			shooter.getFirstAlive().kill();
		}
	}
}


class Ragdoll extends FlxGroup 
{
	var sprites:Array<FlxPhysSprite>;
	
	var rULeg:FlxPhysSprite; // right upper leg.
	var rLLeg:FlxPhysSprite; // right lower leg.
	var lULeg:FlxPhysSprite; // left upper leg.
	var lLLeg:FlxPhysSprite; // left lower leg.
	
	var rUArm:FlxPhysSprite; // right upper arm.
	var rLArm:FlxPhysSprite; // right lower arm.
	var lUArm:FlxPhysSprite; // left upper arm.
	var lLArm:FlxPhysSprite; // left lower arm.
	
	var neck:FlxPhysSprite;
	var head:FlxPhysSprite; // head.
	
	var lTorso:FlxPhysSprite; // lower torso.
	var uTorso:FlxPhysSprite; // upper torso.
	
	var scale:Float;
	
	var joints:Array<PivotJoint>;
	
	var larmSize:FlxPoint;
	var uarmSize:FlxPoint;
	var llegSize:FlxPoint;
	var ulegSize:FlxPoint;
	var uTorsoSize:FlxPoint;
	var lTorsoSize:FlxPoint;
	var neckSize:FlxPoint;
	var headRadius:Float;
	
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
		
		larmSize = new FlxPoint(10, 30);
		uarmSize = new FlxPoint(10, 30);
		llegSize = new FlxPoint(10, 30);
		ulegSize = new FlxPoint(10, 30);
		uTorsoSize = new FlxPoint(25, 30);
		lTorsoSize = new FlxPoint(25, 15);
		neckSize = new FlxPoint(10, 20);
		headRadius = 10;
		
		startX = X;
		startY = Y;
	}
	
	public function init()
	{
		sprites = new Array<FlxPhysSprite>();
		
		uTorso = new FlxPhysSprite(startX, startY); add(uTorso); sprites.push(uTorso); 
		lTorso = new FlxPhysSprite(startX, startY + 30); add(lTorso); sprites.push(lTorso);
		
		rULeg = new FlxPhysSprite(startX + 20, startY + 100); add(rULeg); sprites.push(rULeg);
		rLLeg = new FlxPhysSprite(startX + 20, startY + 150); add(rLLeg); sprites.push(rLLeg);
		lULeg = new FlxPhysSprite(startX - 20, startY + 100); add(lULeg); sprites.push(lULeg);
		lLLeg = new FlxPhysSprite(startX - 20, startY + 150); add(lLLeg); sprites.push(lLLeg);
		
		rUArm = new FlxPhysSprite(startX + 20, startY); add(rUArm); sprites.push(rUArm);
		rLArm = new FlxPhysSprite(startX + 20, startY); add(rLArm); sprites.push(rLArm);
		lUArm = new FlxPhysSprite(startX - 20, startY); add(lUArm); sprites.push(lUArm);
		lLArm = new FlxPhysSprite(startX - 20, startY); add(lLArm); sprites.push(lLArm);
		
		neck = new FlxPhysSprite(startX, startY - 20); add(neck); sprites.push(neck);
		head = new FlxPhysSprite(startX, startY - 40); add(head); sprites.push(head);
		
		
		createBodies();
		createFilterGroups();
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
		
		neck.createRectangularBody(neckSize.x, neckSize.y);
		head.createCircularBody(headRadius);
	}
	
	function createFilterGroups()
	{
		// group 11 1 - lower left leg ignores upper left leg 
		// group 12 2- lower right leg ignores upper right leg
		// group 21 4- upper left legs ignores lower torso 
		// group 22 8- upper rigth legs ignores lower torso 
		// group 3  16- lower torso ignores upper torso
		// group 4  32- upper torso ignores upper arms 
		// group 5  64- upper arms ignores lower arms | upper torso | lower torso
		// group 6  128- lower arms
		// group 7  256- neck ignores head | uppertorso
		// group 8  512- head
		
		lLLeg.body.setShapeFilters(new InteractionFilter(1, ~4)); 
		rLLeg.body.setShapeFilters(new InteractionFilter(2, ~8));
		
		lULeg.body.setShapeFilters(new InteractionFilter(4, ~16));
		rULeg.body.setShapeFilters(new InteractionFilter(8, ~16));
		
		lTorso.body.setShapeFilters(new InteractionFilter(16, ~32));
		uTorso.body.setShapeFilters(new InteractionFilter(32, ~64));
		
		lUArm.body.setShapeFilters(new InteractionFilter(64, ~128));
		rUArm.body.setShapeFilters(new InteractionFilter(64, ~128));
		
		lLArm.body.setShapeFilters(new InteractionFilter(128));
		rLArm.body.setShapeFilters(new InteractionFilter(128));
		
		neck.body.setShapeFilters(new InteractionFilter(256, ~(512 | 32)));
		head.body.setShapeFilters(new InteractionFilter(512));
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
		constrain = new PivotJoint(lULeg.body, lTorso.body, new Vec2(0, -ulegSize.y / 2 + 3), new Vec2(-lTorsoSize.x / 2  + ulegSize.x / 2, lTorsoSize.y / 2 - 3));
		constrain.space = FlxPhysState.space;
		constrain = new PivotJoint(rULeg.body, lTorso.body, new Vec2(0, -ulegSize.y / 2 + 3), new Vec2(lTorsoSize.x / 2  - ulegSize.x / 2, lTorsoSize.y / 2 - 3));
		constrain.space = FlxPhysState.space;
		
		// Upper torso with lower torso.
		weldJoint = new WeldJoint(uTorso.body, lTorso.body, new Vec2(0, uTorsoSize.y / 2 - 3), new Vec2(0, -lTorsoSize.y / 2 - 3));
		weldJoint.space = FlxPhysState.space;
		
		// Upper arms with Upper torso.
		constrain = new PivotJoint(lUArm.body, uTorso.body, new Vec2(uarmSize.x / 2 - 3, -uarmSize.y / 2 + 3), new Vec2(-uTorsoSize.x / 2 + 3, -uTorsoSize.y / 2 + 3));
		constrain.space = FlxPhysState.space;
		constrain = new PivotJoint(rUArm.body, uTorso.body, new Vec2(-uarmSize.x / 2 + 3, -uarmSize.y / 2 + 3), new Vec2(uTorsoSize.x / 2 - 3, -uTorsoSize.y / 2 + 3));
		constrain.space = FlxPhysState.space;
		
		// Neck with upper torso.
		weldJoint = new WeldJoint(neck.body, uTorso.body, new Vec2(0, neckSize.y / 4), new Vec2(0, -uTorsoSize.y / 2  + 3));
		weldJoint.space = FlxPhysState.space;
		// Neck with head.
		constrain = new PivotJoint(neck.body, head.body, new Vec2(0, -neckSize.y / 4 ), new Vec2(0, headRadius));
		constrain.space = FlxPhysState.space;
	}
}