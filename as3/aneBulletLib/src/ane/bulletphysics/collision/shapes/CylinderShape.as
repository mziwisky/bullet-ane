package ane.bulletphysics.collision.shapes
{
	public class CylinderShape extends CollisionShape
	{
		public function CylinderShape(radius_xz:Number=50, height_y:Number=100)
		{
			pointer = extContext.call("createCylinderShape", radius_xz*2*_scaling, height_y*_scaling, radius_xz*2*_scaling) as uint;
		}
	}
}