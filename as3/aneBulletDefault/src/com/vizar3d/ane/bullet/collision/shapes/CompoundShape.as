package com.vizar3d.ane.bullet.collision.shapes
{
	import flash.geom.Matrix3D;

	public class CompoundShape extends CollisionShape
	{
		public function CompoundShape()
		{
			noSupport();
		}
		
		public function addChildShape(shape:CollisionShape, localTransform:Matrix3D): void {
			noSupport();
		}
		
		public function removeChildShape(shape:CollisionShape): void {
			noSupport();
		}
	}
}