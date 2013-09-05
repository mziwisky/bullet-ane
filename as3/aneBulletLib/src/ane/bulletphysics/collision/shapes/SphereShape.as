package ane.bulletphysics.collision.shapes
{	
	public class SphereShape extends CollisionShape
	{
		public function SphereShape(radius:Number=50)
		{
			pointer = extContext.call("createSphereShape", radius/_scaling) as uint;
		}
	}
}