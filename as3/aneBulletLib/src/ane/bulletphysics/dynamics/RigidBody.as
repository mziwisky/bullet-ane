package ane.bulletphysics.dynamics
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.collision.dispatch.CollisionObject;
	import ane.bulletphysics.collision.shapes.CollisionShape;
	import ane.bulletphysics.dynamics.constraintsolver.TypedConstraint;
	
	import away3d.containers.ObjectContainer3D;
	
	public class RigidBody extends CollisionObject
	{
		private var _mass: Number;
		private const _linearFactor: Vector3D = new Vector3D(1, 1, 1);
		private const _angularFactor: Vector3D = new Vector3D(1, 1, 1);
		private const _constraintRefs: Vector.<TypedConstraint> = new Vector.<TypedConstraint>();
		
		public function RigidBody(shape:CollisionShape, skin:ObjectContainer3D, mass:Number, inertia:Vector3D=null) {
			super(shape, skin, extContext.call("createRigidBody", shape.pointer, mass, inertia) as uint);
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
			setMassProps(val);
		}
		
		public function setMassProps(mass:Number, inertia:Vector3D=null): void {
//			if (inertia) {
//				inertia = inertia.clone();
//				inertia.scaleBy(_scaling);
//			}
			extContext.call("RigidBody::setMassProps", pointer, mass, inertia);
			_mass = mass;
		}
		
		public function get inertia(): Vector3D {
			var invInert: Vector3D = extContext.call("RigidBody::getInvInertiaDiagLocal", pointer) as Vector3D;
			var inert: Vector3D = new Vector3D(
				invInert.x ? 1.0 / invInert.x : 0.0,
				invInert.y ? 1.0 / invInert.y : 0.0,
				invInert.z ? 1.0 / invInert.z : 0.0);
//			inert.scaleBy(1.0 / _scaling);
			return inert;
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
			extContext.call("RigidBody::applyCentralImpulse", pointer, impulse);
		}
		
		public function get linearVelocity(): Vector3D {
			return extContext.call("RigidBody::getLinearVelocity", pointer) as Vector3D;
		}
		
		public function set linearVelocity(val:Vector3D): void {
			extContext.call("RigidBody::setLinearVelocity", pointer, val);
		}
		
		public function get angularVelocity(): Vector3D {
			return extContext.call("RigidBody::getAngularVelocity", pointer) as Vector3D;
		}
		
		public function set angularVelocity(val:Vector3D): void {
			extContext.call("RigidBody::setAngularVelocity", pointer, val);
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
		
		public function get gravity(): Vector3D {
			return extContext.call("RigidBody::getGravity", pointer) as Vector3D;
		}
		
		public function set gravity(grav:Vector3D): void {
			extContext.call("RigidBody::setGravity", pointer, grav);
		}
		
		public function get linearDamping(): Number {
			return extContext.call("RigidBody::getLinearDamping", pointer) as Number;
		}
		
		public function set linearDamping(val:Number):void {
			extContext.call("RigidBody::setLinearDamping", pointer, val);
		}
		
		public function get angularDamping(): Number {
			return extContext.call("RigidBody::getAngularDamping", pointer) as Number;
		}
		
		public function set angularDamping(val:Number):void {
			extContext.call("RigidBody::setAngularDamping", pointer, val);
		}
	}
}