package com.vizar3d.ane.bullet.collision.dispatch
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	public class CollisionObject extends BulletBase
	{
		public static const STATIC_OBJECT: int = 1;
		public static const KINEMATIC_OBJECT: int = 2;
		public static const NO_CONTACT_RESPONSE: int = 4;
		public static const CUSTOM_MATERIAL_CALLBACK: int = 8;
		public static const CHARACTER_OBJECT: int = 16;
		public static const DISABLE_VISUALIZE_OBJECT: int = 32;
		public static const DISABLE_SPU_COLLISION_PROCESSING: int = 64;
		
		public function CollisionObject(shape:CollisionShape, skin:ObjectContainer3D, pointer:uint=0) {
			noSupport();
		}
		
		public function get worldTransform(): Matrix3D {
			noSupport(); return null;
		}
		
		public function set worldTransform(val:Matrix3D): void {
			noSupport();
		}
		
		public function get position(): Vector3D {
			noSupport(); return null;
		}
		
		public function set position(val:Vector3D): void {
			noSupport();
		}
		
		public function get collisionFlags(): int {
			noSupport(); return null;
		}
		
		public function set collisionFlags(flags:int): void {
			noSupport();
		}
		
		public function activate(forceActivation:Boolean=false): void {
			noSupport();
		}
	}
}