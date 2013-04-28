package ;

import com.haxepunk.HXP;
import flash.geom.Matrix;
import nme.Assets;
import nme.display.Sprite;
import haxe.Timer;
import nme.text.TextField;
import nme.events.Event;
import nme.text.TextFormat;
import StringTools;

/**
 * ...
 * @author Nicolò Pretto - lordkryss
 */
class Profiler extends Sprite
{
  static var totalTime:Int;
	static var profiles:Hash<Profile>;
	
	private var textField:TextField;
	
	private var lastUpdate:Float;
	
	public function new() 
	{
		super();
		var width = 200;
		var height = 100;
		graphics.beginFill(0x000000, 0.66);
		graphics.drawRect(0, 0, width, height);
		textField = new TextField();
		textField.width = this.width;
		textField.textColor = 0xAAAAAA;
		addChild(textField);
		addEventListener(Event.ENTER_FRAME, update);
		lastUpdate = Timer.stamp();
		
		profiles = new Hash<Profile>();
	}
	
	private function update(e:Event):Void 
	{
		if (Timer.stamp() - lastUpdate > 1 / 30)
		{
			textField.text = "";
			for (p in profiles)
			{
				textField.appendText( p.name+"\t" + p.ticksThisFrame + " \t"+p.time+"\n");
			}
			lastUpdate = Timer.stamp();
		}
	}
	
	static public function start(f:String)
	{
		if (profiles == null)
			profiles = new Hash<Profile>();
		if (profiles.exists(f))
		{
			var p:Profile = profiles.get(f);
			if (p.start != -1)
				trace("something really wrong happened!!");
			p.start = Timer.stamp() * 1000;
			p.ticksThisFrame++;
			p.totalTicks++;
		}else
		{
			var p:Profile = {name : StringTools.rpad(f.substr(0,10)," ",15), start : Timer.stamp()*1000,time:0,totalTicks:0,ticksThisFrame:0}
			profiles.set(f, p);
		}
	}
	
	static public function stop(f:String) 
	{
		if (profiles.exists(f))
		{
			var p:Profile = profiles.get(f);
			p.time += Timer.stamp()*1000 - p.start;
			p.start = -1;
		}else
		{
			trace("stopping a profile you never created!");
		}
	}
	
	static public function newFrame() 
	{
		for (p in profiles)
		{
			p.ticksThisFrame = 0;
			p.time = 0;
		}
	}
}

typedef Profile = {
	name:String,
	start:Float,
	time:Float,
	totalTicks:Int,
	ticksThisFrame:Int,
}
