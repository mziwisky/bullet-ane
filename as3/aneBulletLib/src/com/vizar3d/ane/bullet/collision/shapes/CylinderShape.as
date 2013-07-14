package com.vizar3d.ane.bullet.collision.shapes
{
	public class CylinderShape extends CollisionShape
	{
		public function CylinderShape(radius:Number=50, height:Number=100)
		{
			pointer = extContext.call("createCylinderShape", radius*2*_scaling, height*_scaling, radius*2*_scaling) as uint;
		}
	}
}