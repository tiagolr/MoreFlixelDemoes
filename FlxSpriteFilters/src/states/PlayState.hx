package states;
import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;
#if flash
import flash.filters.BevelFilter;
import flash.filters.DisplacementMapFilter;
import flash.filters.DisplacementMapFilterMode;
#end
import nme.Assets;
import nme.display.BitmapData;
import nme.filters.BitmapFilter;
import nme.filters.BlurFilter;
import nme.filters.DropShadowFilter;
import nme.filters.GlowFilter;
import nme.geom.Point;
import org.flixel.FlxG;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;



/**
 * @author 
 */

class PlayState extends FlxState
{
	var spr1:FlxSprite;
	var spr2:FlxSprite;
	var spr3:FlxSprite;
	var spr4:FlxSprite;
	var spr5:FlxSprite;
	var spr6:FlxSprite;
	
	var txt1:FlxText;
	var txt2:FlxText;
	var txt3:FlxText;
	var txt4:FlxText;
	var txt5:FlxText;
	var txt6:FlxText;
	
	var filter1:BitmapFilter;
	var filter2:GlowFilter;
	var filter3:BlurFilter;
	var filter4:DropShadowFilter;
	#if flash
	var filter5:BevelFilter;
	var filter6:DisplacementMapFilter;
	#end
	
	var isAnimSpr1:Bool;
	var isAnimSpr2:Bool;
	var isAnimSpr3:Bool;
	var isAnimSpr4:Bool;
	var isAnimSpr5:Bool;
	var isAnimSpr6:Bool;
	
	override public function create():Void 
	{
		#if !neko
		FlxG.bgColor = 0xFF01355F;
		#else
		FlxG.camera.bgColor = {rgb: 0x01355F, a: 0xFF};
		#end
		
		FlxG.mouse.show();
		
		var txt:FlxText = new FlxText(0, 10, 640, " Sprite filters - click on each sprite to animate or stop animation. ", 8);
		txt.color = 0xAAAAAA;
		txt.alignment = "center";
		add (txt);
		
		// SPRITES

		spr1 = new FlxSprite(FlxG.width * 0.25 - 50, FlxG.height / 2 - 100 - 50, "assets/HaxeFlixel.png"); 
		spr1.antialiasing = true;
		add(spr1);
		txt1 = new FlxText(spr1.x, spr1.y + 120, 100, "No Filter", 10);
		txt1.alignment = "center";
		add(txt1);
		
		spr2 = new FlxSprite(FlxG.width * 0.5 - 50, FlxG.height / 2 - 100 - 50, "assets/HaxeFlixel.png");
		add(spr2);
		txt2 = new FlxText(spr2.x, spr2.y + 120, 100, "Glow", 10);
		txt2.alignment = "center";
		add(txt2);
		
		spr3 = new FlxSprite(FlxG.width * 0.75 - 50, FlxG.height / 2 - 100 - 50, "assets/HaxeFlixel.png");
		add(spr3);
		txt3 = new FlxText(spr3.x, spr3.y + 120, 100, "Blur", 10);
		txt3.alignment = "center";
		add(txt3);
		
		spr4 = new FlxSprite(FlxG.width * 0.25 - 50, FlxG.height / 2 + 100 - 50, "assets/HaxeFlixel.png");
		add(spr4);
		txt4 = new FlxText(spr4.x, spr4.y + 120, 100, "Drop Shadow", 10);
		txt4.alignment = "center";
		add(txt4);
		
		spr5 = new FlxSprite(FlxG.width * 0.5 - 50, FlxG.height / 2 + 100 - 50, "assets/HaxeFlixel.png");
		add(spr5);
		txt5 = new FlxText(spr5.x, spr5.y + 120, 100, "Bevel\n( flash only )", 10);
		txt5.alignment = "center";
		add(txt5);
		
		spr6 = new FlxSprite(FlxG.width * 0.75 - 50, FlxG.height / 2 + 100 - 50, "assets/HaxeFlixel.png");
		add(spr6);
		txt6 = new FlxText(spr6.x, spr6.y + 120, 100, "Displacement\n( flash only )", 10);
		txt6.alignment = "center";
		add(txt6);
		
		// FILTERS
		
		filter2 = new GlowFilter(0xFF0000, 1, 50, 50, 1.5, 1);
		spr2.addFilter(filter2, new FlxPoint(50, 50));
		
		filter3 = new BlurFilter();
		spr3.addFilter(filter3, new FlxPoint(50, 50));
		sp3.add
		
		filter4 = new DropShadowFilter(10, 45, 0, .75,10,10,1,1);
		spr4.addFilter(filter4, new FlxPoint(30, 30));
		
		#if flash
		filter5 = new BevelFilter(6);
		spr5.addFilter(filter5, new FlxPoint(10, 10));
		
		filter6 = (new DisplacementMapFilter( Assets.getBitmapData("assets/StaticMap.png"), 
						new Point(0, 0), 1, 1, 15, 1, DisplacementMapFilterMode.COLOR, 1, 0 ));
		spr6.addFilter(filter6, new FlxPoint(30, 30));
		#end
		updateDisplaceFilter(); // 
		
		// Animations
		Actuate.tween(filter2, 1, { blurX:4, blurY:4 } ).repeat().reflect().onUpdate(updateSprite, [spr2]).ease(Linear.easeNone);
		Actuate.pause(filter2);
		
		Actuate.tween(filter3, 1.5, { blurX:50, blurY:50 } ).delay(0.5).repeat().reflect().onUpdate(updateSprite, [spr3]).ease(Linear.easeNone);
		Actuate.pause(filter3);
		
		#if flash
		Actuate.tween(filter5, 1, { distance:-6} ).delay(0.5).repeat().reflect().onUpdate(updateSprite, [spr5]).ease(Linear.easeNone);
		Actuate.pause(filter5);
		#end
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.mouse.justPressed())
		{
			if (spr1.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true))
			{
				isAnimSpr1 = !isAnimSpr1; // Toggle animation.
			}
			else
			if (spr2.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true))
			{
				isAnimSpr2 = !isAnimSpr2; // Toggle animation.
				if (isAnimSpr2) 
				{
					Actuate.resume(filter2);
				} 
				else
				{
					Actuate.pause(filter2);
				}
			}
			else
			if (spr3.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true))
			{
				isAnimSpr3 = !isAnimSpr3; // Toggle animation.
				if (isAnimSpr3) 
				{
					Actuate.resume(filter3);
				} 
				else
				{
					Actuate.pause(filter3);
				}
			}
			else
			if (spr4.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true))
			{
				isAnimSpr4 = !isAnimSpr4; // Toggle animation.
			}
			else
			if (spr5.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true))
			{
				isAnimSpr5 = !isAnimSpr5; // Toggle animation.
				if (isAnimSpr5) 
				{
					#if flash
					Actuate.resume(filter5);
					#end
				} 
				else
				{
					#if flash
					Actuate.pause(filter5);
					#end
				}
			}
			else
			if (spr6.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true))
			{
				isAnimSpr6 = !isAnimSpr6; // Toggle animation.
			} 
		}
		
		
		if (isAnimSpr1)
		{
			spr1.angle += 45 * FlxG.elapsed;
		}
		if (isAnimSpr4)
		{
			updateDropShadowFilter();
		}
		if (isAnimSpr6)
		{
			updateDisplaceFilter();
		}
	}
	
	function updateDisplaceFilter()
	{
		#if flash
		filter6.scaleX = Math.random() * 20 - 10; // random between -10 and 10;
		filter6.mapPoint = new Point(0, Math.random() * 30);
		spr6.dirty = true;
		#end
	}
	
	function updateDropShadowFilter()
	{
		#if flash
		filter4.angle -= 360 * FlxG.elapsed;
		spr4.dirty = true;
		#end
	}
	
	function updateSprite(spr:FlxSprite)
	{
		spr.dirty = true;
	}
}