package com.vizar3d.ane.bullet.dynamics.constraintsolver
{
	import com.vizar3d.ane.bullet.BulletMath;
	import com.vizar3d.ane.bullet.awp;
	import com.vizar3d.ane.bullet.dynamics.RigidBody;
	
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
			// TODO: AWPGeneric6DofConstraint.setAngularLimits() is a fucker.  It normalizes its parameters, thereby changing the meaning
			// of the function.
		}
	}
}