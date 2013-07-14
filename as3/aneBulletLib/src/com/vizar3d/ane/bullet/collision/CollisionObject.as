package com.vizar3d.ane.bullet.collision
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.BulletMath;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	public class CollisionObject extends BulletBase
	{
		private var _skin: ObjectContainer3D;
		
		public function CollisionObject(shape:CollisionShape, skin:ObjectContainer3D, pointer:uint=0) {
			_skin = skin;
			if (!pointer) {
				this.pointer = extContext.call("createCollisionObject", shape.pointer) as uint;
				if (skin) {
					// TODO: consider whether you want the skin's transform and the shape's transform to mirror each
					// other like this, and if so, whether you want it to happen right from construction or not.
					worldTransform = skin.transform;
				}
			} else {
				this.pointer = pointer;
			}
		}
		
		public function get skin(): ObjectContainer3D {
			return _skin;
		}
		
		public function get worldTransform(): Matrix3D {
			const btTrans: Matrix3D = extContext.call("CollisionObject::getWorldTransform", pointer) as Matrix3D;
			return BulletMath.transformBulletToA3D(btTrans);
		}
		
		public function set worldTransform(val:Matrix3D): void {
			if (skin) {
				skin.transform = val.clone();
			}
			extContext.call("CollisionObject::setWorldTransform", pointer, BulletMath.transformA3DtoBullet(val));
		}
		
		public function get position(): Vector3D {
			return worldTransform.position;
		}
		
		public function set position(val:Vector3D): void {
			const trans: Matrix3D = worldTransform;
			trans.position = val;
			worldTransform = trans;
		}
	}
}