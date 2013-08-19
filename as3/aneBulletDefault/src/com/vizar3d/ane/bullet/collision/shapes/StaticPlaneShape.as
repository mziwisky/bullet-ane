package com.vizar3d.ane.bullet.collision.shapes
{
	import com.vizar3d.ane.bullet.awp;
	
	import flash.geom.Vector3D;
	
	import awayphysics.collision.shapes.AWPStaticPlaneShape;

	use namespace awp;
	
	public class StaticPlaneShape extends CollisionShape
	{
		public function StaticPlaneShape(normal:Vector3D, constant:Number)
		{
			awpShape = new AWPStaticPlaneShape(normal, constant);
		}
	}
}