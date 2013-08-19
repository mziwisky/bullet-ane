package com.vizar3d.ane.bullet.collision.shapes
{
	import com.vizar3d.ane.bullet.awp;
	
	import awayphysics.collision.shapes.AWPBoxShape;
	
	use namespace awp;
	
	public class BoxShape extends CollisionShape
	{
		public function BoxShape(x_size:Number=100, y_size:Number=100, z_size:Number=100) {
			awpShape = new AWPBoxShape(x_size, y_size, z_size);
		}
	}
}