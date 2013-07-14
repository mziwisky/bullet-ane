package com.vizar3d.ane.bullet.collision
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	public class CollisionObject extends BulletBase
	{
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
	}
}