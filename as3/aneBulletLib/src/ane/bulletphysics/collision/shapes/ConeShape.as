package ane.bulletphysics.collision.shapes
{
	public class ConeShape extends CollisionShape
	{
		public function ConeShape(radius:Number=50, height:Number=100)
		{
			pointer = extContext.call("createConeShape", radius/_scaling, height/_scaling) as uint;
		}
	}
}