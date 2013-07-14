package com.vizar3d.ane.bullet.collision.shapes
{
	import flash.geom.Vector3D;

	public class StaticPlaneShape extends CollisionShape
	{
		public function StaticPlaneShape(normal:Vector3D, constant:Number)
		{
			pointer = extContext.call("createStaticPlaneShape", normal.x, normal.y, normal.z, constant*_scaling) as uint;
		}
	}
}