package
{	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class aneBulletTester extends Sprite
	{
		public function aneBulletTester()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
//			addChild(new AneTest());
//			addChild(new AwayPhysTest());
//			addChild(new AneCompoundShapeTest());
//			addChild(new AwayCompoundShapeTest());
			addChild(new AneGravityTest());
//			addChild(new AwayGravityTest());
//			addChild(new AneBangStuffTogetherTest());
//			addChild(new AwayBangStuffTogetherTest());
		}
	}
}