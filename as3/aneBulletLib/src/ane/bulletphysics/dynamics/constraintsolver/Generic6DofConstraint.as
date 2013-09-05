package ane.bulletphysics.dynamics.constraintsolver
{
	import ane.bulletphysics.BulletMath;
	import ane.bulletphysics.dynamics.RigidBody;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class Generic6DofConstraint extends TypedConstraint
	{
		public function Generic6DofConstraint(rbA:RigidBody, framePosInA:Vector3D, frameRotInA:Vector3D,
											  rbB:RigidBody, framePosInB:Vector3D, frameRotInB:Vector3D,
											  useLinearReferenceFrameA:Boolean=true) {
			// compose A and B transforms
			var transA: Matrix3D = new Matrix3D();
			var transB: Matrix3D = new Matrix3D();
			var scaling: Vector3D = new Vector3D(1, 1, 1);
			
			transA.recompose(new <Vector3D>[framePosInA, frameRotInA, scaling]);
			transB.recompose(new <Vector3D>[framePosInB, frameRotInB, scaling]);
			
			BulletMath.scaleTransformA3DtoBullet(transA, transA);
			BulletMath.scaleTransformA3DtoBullet(transB, transB);
			
			pointer = extContext.call("createGeneric6DofConstraint", rbA.pointer, rbB.pointer,
				transA, transB, useLinearReferenceFrameA) as uint;
		}
		
		public function setLinearLimits(lower:Vector3D, upper:Vector3D): void {
			var scaledLower:Vector3D = lower.clone();
			scaledLower.scaleBy(1.0/_scaling);
			var scaledUpper:Vector3D = upper.clone();
			scaledUpper.scaleBy(1.0/_scaling);
			extContext.call("Generic6DofConstraint::setLinearLimits", pointer, scaledLower, scaledUpper);
		}
		
		public function setAngularLimits(lower:Vector3D, upper:Vector3D): void {
			extContext.call("Generic6DofConstraint::setAngularLimits", pointer, lower, upper);
		}
	}
}