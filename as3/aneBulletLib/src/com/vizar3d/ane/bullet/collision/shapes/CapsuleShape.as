package com.vizar3d.ane.bullet.collision.shapes
{
	public class CapsuleShape extends CollisionShape
	{
		public function CapsuleShape(radius:Number=50, height:Number=100)
		{
			pointer = extContext.call("createCapsuleShape", radius*_scaling, height*_scaling) as uint;
		}
	}
}