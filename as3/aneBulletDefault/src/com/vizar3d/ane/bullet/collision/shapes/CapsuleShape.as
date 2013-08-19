package com.vizar3d.ane.bullet.collision.shapes
{
	import com.vizar3d.ane.bullet.awp;
	
	import awayphysics.collision.shapes.AWPCapsuleShape;

	use namespace awp;
	
	public class CapsuleShape extends CollisionShape
	{
		public function CapsuleShape(radius:Number=50, height:Number=100)
		{
			awpShape = new AWPCapsuleShape(radius, height);
		}
	}
}