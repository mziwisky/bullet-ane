package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.collision.dispatch.CollisionObject;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	import com.vizar3d.ane.bullet.dynamics.constraintsolver.TypedConstraint;
	
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	public class RigidBody extends CollisionObject
	{
		public function RigidBody(shape:CollisionShape, skin:ObjectContainer3D, mass:Number) {
			super(shape, skin, 0); noSupport();
		}
		
		internal function updateSkinTransform(nestedMesh:Boolean=false): void {
			noSupport();
		}
		
		public function get mass(): Number {
			noSupport(); return null;
		}
		
		public function set mass(val:Number): void {
			noSupport();
		}
		
		public function get linearFactor(): Vector3D {
			noSupport(); return null;
		}
		
		public function set linearFactor(val:Vector3D): void {
			noSupport();
		}
		
		public function get angularFactor(): Vector3D {
			noSupport(); return null;
		}
		
		public function set angularFactor(val:Vector3D): void {
			noSupport();
		}
		
		public function applyCentralImpulse(impulse:Vector3D): void {
			noSupport();
		}
		
		public function get linearVelocity(): Vector3D {
			noSupport(); return null;
		}
		
		public function set linearVelocity(val:Vector3D): void {
			noSupport();
		}
		
		public function get angularVelocity(): Vector3D {
			noSupport(); return null;
		}
		
		public function set angularVelocity(val:Vector3D): void {
			noSupport();
		}
		
		public function applyCentralForce(force:Vector3D): void {
			noSupport();
		}
		
		public function applyTorque(torque:Vector3D): void {
			noSupport();
		}
		
		public function applyTorqueImpulse(timpulse:Vector3D): void {
			noSupport();
		}
		
		public function addConstraintRef(constraint:TypedConstraint): void {
			noSupport();
		}
		
		public function removeConstraintRef(constraint:TypedConstraint): void {
			noSupport();		}
		
		public function getConstraintRef(index:int): TypedConstraint {
			noSupport(); return null;
		}
		
		public function getNumConstraintRefs(): int {
			noSupport(); return null;
		}
	}
}