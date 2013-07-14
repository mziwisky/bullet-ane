package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.BulletMath;
	import com.vizar3d.ane.bullet.collision.CollisionObject;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	public class RigidBody extends CollisionObject
	{
		private var _mass: Number;
		private const _linearFactor: Vector3D = new Vector3D(1, 1, 1);
		private const _angularFactor: Vector3D = new Vector3D(1, 1, 1);
		
		public function RigidBody(shape:CollisionShape, skin:ObjectContainer3D, mass:Number) {
			
			super(shape, skin, extContext.call("createRigidBody", shape.pointer, BulletMath.transformA3DtoBullet(skin.transform), mass) as uint);
			_mass = mass;
		}
		
		internal function updateSkinTransform(): void {
			if (skin) {
				skin.transform = worldTransform;
			}
		}
		
		public function get mass(): Number {
			return _mass;
		}
		
		public function set mass(val:Number): void {
			extContext.call("RigidBody::setMass", pointer, val);
			_mass = val;
			// TODO: notify discreteDynamicsWorld if I've gone from static to non-static or vice-versa (use a Signal)
		}
		
		public function get linearFactor(): Vector3D {
			return _linearFactor;
		}
		
		public function set linearFactor(val:Vector3D): void {
			extContext.call("RigidBody::setLinearFactor", pointer, val);
			_linearFactor.copyFrom(val);
		}
		
		public function get angularFactor(): Vector3D {
			return _angularFactor;
		}
		
		public function set angularFactor(val:Vector3D): void {
			extContext.call("RigidBody::setAngularFactor", pointer, val);
			_angularFactor.copyFrom(val);
		}
		
		public function applyCentralImpulse(impulse:Vector3D) : void {
			const scaled: Vector3D = impulse.clone();
			scaled.scaleBy(_scaling);
			extContext.call("RigidBody::applyCentralImpulse", pointer, scaled);
//			const vec : Vector3D = BulletMath.vectorComponentMultiply(impulse, _linearFactor);
//			vec.scaleBy(1/mass);
//			m_linearVelocity.v3d = vec.add(m_linearVelocity.v3d);
//			activate();
		}
		
		public function get linearVelocity(): Vector3D {
			const vel: Vector3D = extContext.call("RigidBody::getLinearVelocity", pointer) as Vector3D;
			vel.scaleBy(1/_scaling);
			return vel;
		}
	}
}