package ane.bulletphysics.dynamics
{
	import flash.geom.Matrix3D;
	
	import away3d.containers.ObjectContainer3D;
	
	import awayphysics.collision.shapes.AWPCollisionShape;
	import awayphysics.dynamics.AWPRigidBody;
	
	public class NestableAWPRigidBody extends AWPRigidBody
	{
		private var nested: Boolean;
		
		public function NestableAWPRigidBody(shape:AWPCollisionShape, skin:ObjectContainer3D, mass:Number, nested:Boolean) {
			super(shape, skin, mass);
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