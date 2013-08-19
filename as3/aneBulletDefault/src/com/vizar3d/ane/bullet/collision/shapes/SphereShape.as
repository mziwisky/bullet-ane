package com.vizar3d.ane.bullet.collision.shapes
{	
	import com.vizar3d.ane.bullet.awp;
	
	import awayphysics.collision.shapes.AWPSphereShape;
	
	use namespace awp;
	
	public class SphereShape extends CollisionShape
	{
		public function SphereShape(radius:Number=50)
		{
			awpShape = new AWPSphereShape(radius);
		}
	}
}