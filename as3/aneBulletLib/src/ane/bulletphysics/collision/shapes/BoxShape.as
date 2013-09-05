package ane.bulletphysics.collision.shapes
{
	public class BoxShape extends CollisionShape
	{
		public function BoxShape(x_size:Number=100, y_size:Number=100, z_size:Number=100)
		{
			pointer = extContext.call("createBoxShape", x_size/_scaling, y_size/_scaling, z_size/_scaling) as uint;
		}
	}
}