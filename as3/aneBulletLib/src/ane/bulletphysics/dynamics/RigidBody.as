package ane.bulletphysics.dynamics
{
	import ane.bulletphysics.collision.dispatch.CollisionObject;
	import ane.bulletphysics.collision.shapes.CollisionShape;
	import ane.bulletphysics.dynamics.constraintsolver.TypedConstraint;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	public class RigidBody extends CollisionObject
	{
		private var _mass: Number;
		private const _linearFactor: Vector3D = new Vector3D(1, 1, 1);
		private const _angularFactor: Vector3D = new Vector3D(1, 1, 1);
		private const _constraintRefs: Vector.<TypedConstraint> = new Vector.<TypedConstraint>();
		
		public function RigidBody(shape:CollisionShape, skin:ObjectContainer3D, mass:Number) {
			
			super(shape, skin, extContext.call("createRigidBody", shape.pointer, /*BulletMath.transformA3DtoBullet(skin.transform),*/ mass) as uint);
			_mass = mass;
		}
		
		internal function updateSkinTransform(): void {
			if (skin) {
				if (nestedMeshes && skin.parent) {
					var xform: Matrix3D = worldTransform;
					xform.append(skin.parent.inverseSceneTransform);
					skin.transform = xform;
				} else {
					skin.transform = worldTransform;
				}
			}
		}
		
		public function get mass(): Number {
			return _mass;
		}
		
		public function set mass(val:Number): void {
			extContext.call("RigidBody::setMass", pointer, val);
			_mass = val;
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
		
		public function applyCentralImpulse(impulse:Vector3D): void {
			const scaled: Vector3D = impulse.clone();
			scaled.scaleBy(_scaling);
			extContext.call("RigidBody::applyCentralImpulse", pointer, scaled);
		}
		
		public function get linearVelocity(): Vector3D {
			const vel: Vector3D = extContext.call("RigidBody::getLinearVelocity", pointer) as Vector3D;
			vel.scaleBy(1/_scaling);
			return vel;
		}
		
		public function set linearVelocity(val:Vector3D): void {
			const linvel: Vector3D = val.clone();
			linvel.scaleBy(_scaling);
			extContext.call("RigidBody::setLinearVelocity", pointer, linvel);
		}
		
		public function get angularVelocity(): Vector3D {
			const vel: Vector3D = extContext.call("RigidBody::getAngularVelocity", pointer) as Vector3D;
			vel.scaleBy(1/_scaling);
			return vel;
		}
		
		public function set angularVelocity(val:Vector3D): void {
			const angvel: Vector3D = val.clone();
			angvel.scaleBy(_scaling);
			extContext.call("RigidBody::setAngularVelocity", pointer, angvel);
		}
		
		public function applyCentralForce(force:Vector3D): void {
			extContext.call("RigidBody::applyCentralForce", pointer, force);
		}
		
		public function applyTorque(torque:Vector3D): void {
			extContext.call("RigidBody::applyTorque", pointer, torque);
		}
		
		public function applyTorqueImpulse(timpulse:Vector3D): void {
			extContext.call("RigidBody::applyTorqueImpulse", pointer, timpulse);
		}
		
		public function addConstraintRef(constraint:TypedConstraint): void {
			extContext.call("RigidBody::addConstraintRef", pointer, constraint.pointer);
			if (_constraintRefs.indexOf(constraint) == -1) {
				_constraintRefs.push(constraint);
			}
		}
		
		public function removeConstraintRef(constraint:TypedConstraint): void {
			extContext.call("RigidBody::removeConstraintRef", pointer, constraint.pointer);
			var index:int = _constraintRefs.indexOf(constraint);
			if (index > -1) {
				_constraintRefs.splice(index, 1);
			}
		}
		
		public function getConstraintRef(index:int): TypedConstraint {
//			extContext.call("RigidBody::getConstraintRef", pointer, index);
			return _constraintRefs.length > index ? _constraintRefs[index] : null;
		}
		
		public function getNumConstraintRefs(): int {
//			return extContext.call("RigidBody::getNumConstraintRefs", pointer) as int;
			return _constraintRefs.length;
		}
	}
}