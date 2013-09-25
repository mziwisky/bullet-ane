package ane.bulletphysics.dynamics.constraintsolver
{
	import ane.bulletphysics.BulletMath;
	import ane.bulletphysics.awp;
	import ane.bulletphysics.dynamics.RigidBody;
	
	import flash.geom.Vector3D;
	
	import awayphysics.dynamics.constraintsolver.AWPGeneric6DofConstraint;
	
	use namespace awp;
	
	public class Generic6DofConstraint extends TypedConstraint
	{
		awp var awpSixdof: AWPGeneric6DofConstraint;
		
		public function Generic6DofConstraint(rbA:RigidBody, framePosInA:Vector3D, frameRotInA:Vector3D,
											  rbB:RigidBody, framePosInB:Vector3D, frameRotInB:Vector3D,
											  useLinearReferenceFrameA:Boolean=true) {
			awpTypedConst = awpSixdof = new AWPGeneric6DofConstraint(rbA.awpBody, framePosInA, BulletMath.v3d_rad2deg(frameRotInA),
				rbB.awpBody, framePosInB, BulletMath.v3d_rad2deg(frameRotInB), useLinearReferenceFrameA);
		}
		
		public function setLinearLimits(lower:Vector3D, upper:Vector3D): void {
			awpSixdof.setLinearLimit(lower, upper);
		}
		
		public function setAngularLimits(lower:Vector3D, upper:Vector3D): void {
			awpSixdof.setAngularLimit(lower, upper);
		}
	}
}