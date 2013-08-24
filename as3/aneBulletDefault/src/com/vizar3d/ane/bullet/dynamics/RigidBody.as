package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.awp;
	import com.vizar3d.ane.bullet.collision.dispatch.CollisionObject;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	import com.vizar3d.ane.bullet.dynamics.constraintsolver.TypedConstraint;
	
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	use namespace awp;
	
	public class RigidBody extends CollisionObject
	{
		awp var awpBody: NestableAWPRigidBody;
		private const _constraintRefs: Vector.<TypedConstraint> = new Vector.<TypedConstraint>();
		
		public function RigidBody(shape:CollisionShape, skin:ObjectContainer3D, mass:Number) {
			awpBody = new NestableAWPRigidBody(shape.awpShape, skin, mass, nestedMeshes);
			super(shape, skin, awpBody);
		}
		
		public function get mass(): Number {
			return awpBody.mass;
		}
		
		public function set mass(val:Number): void {
			awpBody.mass = val;
		}
		
		public function get linearFactor(): Vector3D {
			return awpBody.linearFactor;
		}
		
		public function set linearFactor(val:Vector3D): void {
			awpBody.linearFactor = val;
		}
		
		public function get angularFactor(): Vector3D {
			return awpBody.angularFactor;
		}
		
		public function set angularFactor(val:Vector3D): void {
			awpBody.angularFactor = val;
		}
		
		public function applyCentralImpulse(impulse:Vector3D): void {
			awpBody.applyCentralImpulse(impulse);
		}
		
		public function get linearVelocity(): Vector3D {
			return awpBody.linearVelocity;
		}
		
		public function set linearVelocity(val:Vector3D): void {
			awpBody.linearVelocity = val;
		}
		
		public function get angularVelocity(): Vector3D {
			return awpBody.angularVelocity;
		}
		
		public function set angularVelocity(val:Vector3D): void {
			awpBody.angularVelocity = val;
		}
		
		public function applyCentralForce(force:Vector3D): void {
			awpBody.applyCentralForce(force);
		}
		
		public function applyTorque(torque:Vector3D): void {
			awpBody.applyTorque(torque);
		}
		
		public function applyTorqueImpulse(timpulse:Vector3D): void {
			awpBody.applyTorqueImpulse(timpulse);
		}
		
		public function addConstraintRef(constraint:TypedConstraint): void {
			if (_constraintRefs.indexOf(constraint) == -1) {
				_constraintRefs.push(constraint);
			}
		}
		
		public function removeConstraintRef(constraint:TypedConstraint): void {
			var index:int = _constraintRefs.indexOf(constraint);
			if (index > -1) {
				_constraintRefs.splice(index, 1);
			}
		}
		
		public function getConstraintRef(index:int): TypedConstraint {
			return _constraintRefs.length > index ? _constraintRefs[index] : null;
		}
		
		public function getNumConstraintRefs(): int {
			return _constraintRefs.length;
		}
	}
}
