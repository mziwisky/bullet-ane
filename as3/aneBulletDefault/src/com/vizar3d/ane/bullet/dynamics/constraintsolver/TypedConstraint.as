package com.vizar3d.ane.bullet.dynamics.constraintsolver
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.awp;
	
	import awayphysics.dynamics.constraintsolver.AWPTypedConstraint;
	
	use namespace awp;
	
	public class TypedConstraint extends BulletBase
	{
		awp var awpTypedConst: AWPTypedConstraint;
		
		public function TypedConstraint()
		{
		}
	}
}