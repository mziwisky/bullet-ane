package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.collision.dispatch.CollisionObject;
	import com.vizar3d.ane.bullet.dynamics.constraintsolver.TypedConstraint;
	
	import flash.geom.Vector3D;

	public class DiscreteDynamicsWorld extends BulletBase
	{
		public static const BROADPHASE_DBVT: String = "dbvt";
		
		public function DiscreteDynamicsWorld(broadphase:String=BROADPHASE_DBVT, scaling=0.01, expectNestedMeshes:Boolean=false) {
			noSupport();
		}
		
		// TODO: dispose
		
		public function addCollisionObject(obj:CollisionObject): void {
			noSupport();
		}
		
		public function removeCollisionObject(obj:CollisionObject): void {
			noSupport();
		}
		
		public function addRigidBody(body:RigidBody): void {
			noSupport();
		}
		
		public function removeRigidBody(body:RigidBody): void {
			noSupport();
		}
		
		public function addConstraint(constraint:TypedConstraint, disableCollisionsBetweenLinkedBodies:Boolean=false): void {
			noSupport();
		}
		
		public function removeConstraint(constraint:TypedConstraint): void {
			noSupport();
		}
		
		public function set gravity(grav:Vector3D): void {
			noSupport();
		}
		
		public function step(timestep:Number, maxsubsteps:int=1, fixedstep:Number=1.0/60.0): void {
			noSupport();
		}
	}
}