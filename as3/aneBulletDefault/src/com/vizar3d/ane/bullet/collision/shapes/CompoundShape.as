package com.vizar3d.ane.bullet.collision.shapes
{
	import com.vizar3d.ane.bullet.awp;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import awayphysics.collision.shapes.AWPCompoundShape;
	
	use namespace awp;
	
	public class CompoundShape extends CollisionShape
	{
		private var cshape: AWPCompoundShape;
		
		public function CompoundShape()
		{
			awpShape = cshape = new AWPCompoundShape();
		}
		
		public function addChildShape(shape:CollisionShape, localTransform:Matrix3D): void {
			var decom: Vector.<Vector3D> = localTransform.decompose();
			var pos: Vector3D = decom[0];
			var rot: Vector3D = decom[1];
			rot.scaleBy(180.0 / Math.PI);
			cshape.addChildShape(shape.awpShape, pos, rot);
		}
		
		public function removeChildShape(shape:CollisionShape): void {
			var index:int = cshape.children.indexOf(shape.awpShape);
			if (index != -1) {
				cshape.removeChildShapeByIndex(index);
			}
		}
	}
}