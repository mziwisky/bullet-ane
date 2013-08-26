package ane.bulletphysics.collision.shapes
{
	import ane.bulletphysics.BulletBase;
	import ane.bulletphysics.awp;
	
	import awayphysics.collision.shapes.AWPCollisionShape;
	
	use namespace awp;

	public class CollisionShape extends BulletBase
	{
		awp var awpShape: AWPCollisionShape;
		
		public function CollisionShape() {}
	}
}