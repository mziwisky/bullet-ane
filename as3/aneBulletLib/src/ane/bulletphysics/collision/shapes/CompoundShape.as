package ane.bulletphysics.collision.shapes
{
	import ane.bulletphysics.BulletMath;
	
	import flash.geom.Matrix3D;

	public class CompoundShape extends CollisionShape
	{
//		private const _children: Vector.<CollisionShape> = new Vector.<CollisionShape>();
//		private const _childTransforms: Vector.<Matrix3D> = new Vector.<Matrix3D>();
		
		public function CompoundShape()
		{
			pointer = extContext.call("createCompoundShape") as uint;
		}
		
		public function addChildShape(shape:CollisionShape, localTransform:Matrix3D): void {
			extContext.call("CompoundShape::addChildShape", pointer, shape.pointer, BulletMath.scaleTransformA3DtoBullet(localTransform));
//			_children.push(shape);
//			// TODO: just realized i accept using the same shape over and over. so... shucks.
//			_childTransforms.push(localTransform.clone());
		}
		
		public function removeChildShape(shape:CollisionShape): void {
			extContext.call("CompoundShape::removeChildShape", pointer, shape.pointer);
//			const index: int = _children.indexOf(shape);
//			if (index != -1) {
//				_children.splice(index, 1);
//				_childTransforms.splice(index, 1);
//			}
			// TODO: look at how AWPCompoundShape also keeps track of _allChildren -- make sure you're managing memory well
		}
	}
}