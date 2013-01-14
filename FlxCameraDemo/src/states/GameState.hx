package states;
import addons.nape.FlxPhysSprite;
import addons.nape.FlxPhysState;
import nape.Config;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.phys.Material;
import nape.shape.Polygon;
import nme.Assets;
import nme.display.BlendMode;
import nme.Lib;
import org.flixel.FlxCamera;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxU;
import HUD;

#if dev
import pgr.gconsole.GC;
#end

/**
 * @author TiagoLr ( ~~~ProG4mr~~~ )
 */

class GameState extends FlxPhysState
{
	static inline var LEVEL_MIN_X = -Lib.current.stage.stageWidth / 2;
	static inline var LEVEL_MAX_X = Lib.current.stage.stageWidth * 1.5;
	static inline var LEVEL_MIN_Y = -Lib.current.stage.stageHeight / 2;
	static inline var LEVEL_MAX_Y = Lib.current.stage.stageHeight * 1.5;
	
	private var orb:Orb;
	private var orbShadow:FlxSprite;
	private var hud:HUD;
	private var hudCam:FlxCamera;
	#if TRUE_ZOOM_OUT
	private var firstUpdate:Bool;
	#end

	override public function create():Void 
	{	
		super.create();
		
		#if TRUE_ZOOM_OUT
		FlxG.width = 640; // For 1/2 zoom out
		FlxG.height = 480; // For 1/2 zoom out
		firstUpdate = true;
		#end
		
		velocityIterations = 5;
		positionIterations = 5;
		
		createFloor();
		createWalls(LEVEL_MIN_X, LEVEL_MIN_Y, LEVEL_MAX_X, LEVEL_MAX_Y);
		// Walls border.
		add(new FlxSprite( -FlxG.width / 2, -FlxG.height / 2, Assets.getBitmapData("assets/Border.png")));
		
		orbShadow = new FlxSprite(FlxG.width / 2, FlxG.height / 2, Assets.getBitmapData("assets/OrbShadow.png"));
		orbShadow.centerOffsets();
		orbShadow.blend = BlendMode.MULTIPLY;
		
		orb = new Orb();
		
		add(orbShadow);
		add(orb);
		
		orb.shadow = orbShadow;
		
		hud = new HUD();
		add(hud);
		
		FlxG.camera.setBounds( LEVEL_MIN_X , LEVEL_MIN_Y , LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true );
		FlxG.camera.follow(orb, 0, null, 0);
		FlxG.camera.followAdjust(0, 0);
		
		disablePhysDebug();
		
		#if dev
		GC.init();
		GC.registerVariable(FlxG.camera.scroll, "x", "scrollX", true);
		GC.registerVariable(FlxG.camera.scroll, "y", "scrollY", true);
		GC.registerVariable(FlxG.camera, "x", "camX", true);
		GC.registerVariable(FlxG.camera, "y", "camY", true);
		GC.registerVariable(FlxG.camera, "width", "camWidth", true);
		GC.registerVariable(FlxG.camera, "height", "camHeight", true);
		GC.registerVariable(FlxG.camera, "zoom", "camZoom");
		GC.registerFunction(this, "setZoom", "zoom"); 
		#end	
		
		#if TRUE_ZOOM_OUT
		hudCam = new FlxCamera(440 + 50, 0 + 45, 200, 180); // +50 + 45 For 1/2 zoom out.
		#else
		hudCam = new FlxCamera(440, 0, 200, 180);
		#end
		hudCam.zoom = 1; // For 1/2 zoom out.
		hudCam.follow(hud.background);
		hudCam.alpha = .5;
		FlxG.addCamera(hudCam);
	}
	
	public function setZoom(zoom:Float)
	{
		if (zoom < .5) zoom = .5;
		if (zoom > 4 ) zoom = 4;
		
		zoom = Math.round(zoom * 10) / 10; // corrects float precision problems.
		
		FlxG.camera.zoom = zoom;
		
		#if TRUE_ZOOM_OUT
		zoom += 0.5; // For 1/2 zoom out.
		zoom -= (1 - zoom); // For 1/2 zoom out.
		#end
		
		var zoomDistDiffY;
		var zoomDistDiffX;
		
		
		if ( zoom <= 1 ) 
		{
			zoomDistDiffX = FlxU.abs((LEVEL_MIN_X + LEVEL_MAX_X) - (LEVEL_MIN_X + LEVEL_MAX_X) / 1 + (1 - zoom));
			zoomDistDiffY = FlxU.abs((LEVEL_MIN_Y + LEVEL_MAX_Y) - (LEVEL_MIN_Y + LEVEL_MAX_Y) / 1 + (1 - zoom));
			#if TRUE_ZOOM_OUT
			zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise -0.5 
			zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise -0.5
			#else
			zoomDistDiffX *= -.5;
			zoomDistDiffY *= -.5;
			#end
		} else
		{
			zoomDistDiffX = FlxU.abs((LEVEL_MIN_X + LEVEL_MAX_X) - (LEVEL_MIN_X + LEVEL_MAX_X) / zoom);
			zoomDistDiffY = FlxU.abs((LEVEL_MIN_Y + LEVEL_MAX_Y) - (LEVEL_MIN_Y + LEVEL_MAX_Y) / zoom);
			#if TRUE_ZOOM_OUT
			zoomDistDiffX *= 1; // For 1/2 zoom out - otherwise 0.5
			zoomDistDiffY *= 1; // For 1/2 zoom out - otherwise 0.5
			#else
			zoomDistDiffX *= .5;
			zoomDistDiffY *= .5;
			#end
		}
		
		FlxG.camera.setBounds( LEVEL_MIN_X - zoomDistDiffX, 
							   LEVEL_MIN_Y - zoomDistDiffY,
							   (LEVEL_MAX_X + Math.abs(LEVEL_MIN_X) + zoomDistDiffX * 2),
							   (LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y) + zoomDistDiffY * 2),
							   false );
							   
		hud.updateZoom(FlxG.camera.zoom);
							
	}

	private function createFloor() 
	{
		// CREATE FLOOR TILES
		var	FloorImg = Assets.getBitmapData("assets/FloorTexture.png");
		var ImgWidth = FloorImg.width;
		var ImgHeight = FloorImg.height;
		var i = LEVEL_MIN_X; 
		var j = LEVEL_MIN_Y; 
		
		while ( i <= LEVEL_MAX_X )  
		{
			while ( j <= LEVEL_MAX_Y )
			{
				var spr = new FlxSprite(i, j, FloorImg);
				add(spr);
				j += ImgHeight;
			}
			i += ImgWidth;
			j = LEVEL_MIN_Y;
		}
	}
	
	override public function update():Void 
	{	
		#if TRUE_ZOOM_OUT
		if (firstUpdate) // For 1/2 zoom out.
		{
			setZoom(1);
			firstUpdate = false;
		}
		#end

		super.update();
		
		var speed = 20;
		if (FlxG.keys.A)
			orb.mainBody.applyImpulse(new Vec2( -speed, 0));
		if (FlxG.keys.S)
			orb.mainBody.applyImpulse(new Vec2( 0, speed));
		if (FlxG.keys.D)
			orb.mainBody.applyImpulse(new Vec2( speed, 0));
		if (FlxG.keys.W)
			orb.mainBody.applyImpulse(new Vec2( 0, -speed));
			
		if (FlxG.keys.justPressed("Y")) 
			setStyle(1);
		if (FlxG.keys.justPressed("H")) 
			setStyle( -1);
			
		if (FlxG.keys.justPressed("U"))
			setLerp(.5);
		if (FlxG.keys.justPressed("J"))
			setLerp( -.5);
			
		if (FlxG.keys.justPressed("I"))
			setLead(.5);
		if (FlxG.keys.justPressed("K"))
			setLead( -.5);
			
		if (FlxG.keys.justPressed("O"))
			setZoom(FlxG.camera.zoom + .1);
		if (FlxG.keys.justPressed("L"))
			setZoom(FlxG.camera.zoom - .1);
			
			
		
	}
	
	private function setLead(lead:Float) 
	{
		var cam = FlxG.camera;
		cam.followLead.x += lead;
		cam.followLead.y += lead;
		
		if (cam.followLead.x < 0) {
			cam.followLead.x = 0;
			cam.followLead.y = 0;
		}
			
		hud.updateCamLead(cam.followLead.x);
	}
	
	private function setLerp(lerp:Float) 
	{
		var cam = FlxG.camera;
		cam.followLerp += lerp;
		
		if (cam.followLerp < 0)
			cam.followLerp = 0;
			
		hud.updateCamLerp(cam.followLerp);
	}
	
	private function setStyle(i:Int) 
	{
		var oldCam:FlxCamera = FlxG.camera;
		
		var newCamStyle:Int = oldCam.style + i;
		newCamStyle < 0 ? newCamStyle = 0 : newCamStyle %= 6;
		
		
		#if TRUE_ZOOM_OUT
		FlxG.camera = FlxG.addCamera(new FlxCamera(Std.int( -640 / 2), Std.int( -480 / 2), 640 * 2, 480 * 2, 1)); 
		#else
		FlxG.camera = FlxG.addCamera(new FlxCamera(0, 0, 640, 480, 1));
		#end
		FlxG._game.swapChildren(FlxG.camera._flashSprite, hudCam._flashSprite);
		
		FlxG.camera.follow(orb, newCamStyle, null, oldCam.followLerp);
		FlxG.camera.followAdjust(oldCam.followLead.x, oldCam.followLead.y);
		setZoom(oldCam.zoom);
		
		FlxG.removeCamera(oldCam, true);
		
		switch (newCamStyle) 
		{
			case 0:hud.updateStyle("STYLE_LOCKON");
			case 1:hud.updateStyle("STYLE_PLATFORMER");
			case 2:hud.updateStyle("STYLE_TOPDOWN");
			case 3:hud.updateStyle("STYLE_TOPDOWN_TIGHT");
			case 4:hud.updateStyle("STYLE_SCREEN_BY_SCREEN");
			case 5:hud.updateStyle("STYLE_NO_DEAD_ZONE");
		}
	}
	
	override public function draw():Void 
	{
		super.draw();
		
	}
}