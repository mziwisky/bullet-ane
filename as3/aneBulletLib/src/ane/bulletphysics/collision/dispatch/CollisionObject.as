package ane.bulletphysics.collision.dispatch
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.BulletBase;
	import ane.bulletphysics.BulletMath;
	import ane.bulletphysics.collision.shapes.CollisionShape;
	
	import away3d.containers.ObjectContainer3D;
	
	public class CollisionObject extends BulletBase
	{
		private var _skin: ObjectContainer3D;
		
		public function CollisionObject(shape:CollisionShape, skin:ObjectContainer3D, pointer:uint=0) {
			_skin = skin;
			if (!pointer) {
				this.pointer = extContext.call("createCollisionObject", shape.pointer) as uint;
				if (skin) {
					// TODO: consider whether you want the skin's transform and the CollisionObject's transform to mirror each
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
			return BulletMath.scaleTransformBulletToA3D(btTrans, btTrans);
		}
		
		public function set worldTransform(val:Matrix3D): void {
			if (skin) {
				var xform: Matrix3D = val.clone();
				if (nestedMeshes && skin.parent) {
					xform.append(skin.parent.inverseSceneTransform);
				}
				skin.transform = xform;
			}
			extContext.call("CollisionObject::setWorldTransform", pointer, BulletMath.scaleTransformA3DtoBullet(val));
		}
		
		public function get position(): Vector3D {
			return worldTransform.position;
		}
		
		public function set position(val:Vector3D): void {
			const trans: Matrix3D = worldTransform;
			trans.position = val;
			worldTransform = trans;
		}
		
		public function get collisionFlags(): int {
			return extContext.call("CollisionObject::getCollisionFlags", pointer) as int;
		}
		
		public function set collisionFlags(flags:int): void {
			extContext.call("CollisionObject::setCollisionFlags", pointer, flags);
		}
		
		public function activate(forceActivation:Boolean=false): void {
			extContext.call("CollisionObject::activate", pointer, forceActivation);
		}
		
		public function get friction(): Number {
			return extContext.call("CollisionObject::getFriction", pointer) as Number;
		}
		
		public function set friction(val:Number): void {
			extContext.call("CollisionObject::setFriction", pointer, val);
		}
		
		public function get rollingFriction(): Number {
			return extContext.call("CollisionObject::getRollingFriction", pointer) as Number;
		}
		
		public function set rollingFriction(val:Number): void {
			extContext.call("CollisionObject::setRollingFriction", pointer, val);
		}
		
		public function get restitution(): Number {
			return extContext.call("CollisionObject::getRestitution", pointer) as Number;
		}
		
		public function set restitution(val:Number): void {
			extContext.call("CollisionObject::setRestitution", pointer, val);
		}
		
		public function get hitFraction(): Number {
			return extContext.call("CollisionObject::getHitFraction", pointer) as Number;
		}
		
		public function set hitFraction(val:Number): void {
			extContext.call("CollisionObject::setHitFraction", pointer, val);
		}
		
		public function get collisionFilterGroup(): int {
			return extContext.call("CollisionObject::getCollisionFilterGroup", pointer) as int;
		}
		
		public function get collisionFilterMask(): int {
			return extContext.call("CollisionObject::getCollisionFilterMask", pointer) as int;
		}
		
		public function set ccdSweptSphereRadius(val:Number): void {
			extContext.call("CollisionObject::setCcdSweptSphereRadius", pointer, val);
		}
		
		public function set ccdMotionThreshold(val:Number): void {
			extContext.call("CollisionObject::setCcdMotionThreshold", pointer, val);
		}
	}
}
