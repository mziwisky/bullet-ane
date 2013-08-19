package com.vizar3d.ane.bullet.collision.shapes
{
	import com.vizar3d.ane.bullet.awp;
	
	import awayphysics.collision.shapes.AWPCylinderShape;

	use namespace awp;
	
	public class CylinderShape extends CollisionShape
	{
		public function CylinderShape(radius_xz:Number=50, height_y:Number=100)
		{
			awpShape = new AWPCylinderShape(radius_xz, height_y);
		}
	}
}