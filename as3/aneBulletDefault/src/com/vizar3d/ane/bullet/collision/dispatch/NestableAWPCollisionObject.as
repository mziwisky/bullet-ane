package com.vizar3d.ane.bullet.collision.dispatch
{
	import flash.geom.Matrix3D;
	
	import away3d.containers.ObjectContainer3D;
	
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.collision.shapes.AWPCollisionShape;
	
	public class NestableAWPCollisionObject extends AWPCollisionObject
	{
		private var nested: Boolean;
		
		public function NestableAWPCollisionObject(shape:AWPCollisionShape, skin:ObjectContainer3D, pointer:uint, nested:Boolean): void {
			super(shape, skin, pointer);
			this.nested = nested;
		}
		
		override public function updateTransform():void {
			if (!nested) super.updateTransform();
			else if (skin && skin.parent) {
				var xform: Matrix3D = this.transform.clone();
				xform.append(skin.parent.inverseSceneTransform);
				skin.transform = xform;
			}
		}
	}
}