package ane.bulletphysics.collision.shapes
{
	import ane.bulletphysics.awp;
	
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