package ane.bulletphysics.collision.shapes
{	
	import ane.bulletphysics.awp;
	
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