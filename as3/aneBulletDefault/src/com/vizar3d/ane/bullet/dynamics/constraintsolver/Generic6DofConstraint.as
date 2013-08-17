package com.vizar3d.ane.bullet.dynamics.constraintsolver
{
	import com.vizar3d.ane.bullet.dynamics.RigidBody;
	
	import flash.geom.Vector3D;

	public class Generic6DofConstraint extends TypedConstraint
	{
		public function Generic6DofConstraint(rbA:RigidBody, framePosInA:Vector3D, frameRotInA:Vector3D,
											  rbB:RigidBody, framePosInB:Vector3D, frameRotInB:Vector3D,
											  useLinearReferenceFrameA:Boolean=true) {
			noSupport();
		}
		
		public function setLinearLimits(lower:Vector3D, upper:Vector3D): void {
			noSupport();
		}
		
		public function setAngularLimits(lower:Vector3D, upper:Vector3D): void {
			noSupport();
		}
	}
}