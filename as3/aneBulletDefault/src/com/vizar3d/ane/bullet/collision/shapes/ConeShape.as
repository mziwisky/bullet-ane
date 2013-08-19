package com.vizar3d.ane.bullet.collision.shapes
{
	import com.vizar3d.ane.bullet.awp;
	
	import awayphysics.collision.shapes.AWPConeShape;
	
	use namespace awp;
	
	public class ConeShape extends CollisionShape
	{
		public function ConeShape(radius:Number=50, height:Number=100)
		{
			awpShape = new AWPConeShape(radius, height);
		}
	}
}