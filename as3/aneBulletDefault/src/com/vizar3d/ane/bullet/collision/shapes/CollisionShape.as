package com.vizar3d.ane.bullet.collision.shapes
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.awp;
	
	import awayphysics.collision.shapes.AWPCollisionShape;
	
	use namespace awp;

	public class CollisionShape extends BulletBase
	{
		awp var awpShape: AWPCollisionShape;
		
		public function CollisionShape() {}
	}
}