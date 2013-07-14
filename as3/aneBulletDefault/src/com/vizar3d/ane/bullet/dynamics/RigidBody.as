package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.collision.CollisionObject;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	public class RigidBody extends CollisionObject
	{
		public function RigidBody(shape:CollisionShape, skin:ObjectContainer3D, mass:Number) {
			super(shape, skin, 0); noSupport();
		}
		
		internal function updateSkinTransform(): void {
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
		
		public function applyCentralImpulse(impulse:Vector3D) : void {
			noSupport();
		}
		
		public function get linearVelocity(): Vector3D {
			noSupport(); return null;
		}
	}
}