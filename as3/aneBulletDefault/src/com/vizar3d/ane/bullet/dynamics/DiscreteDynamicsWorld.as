package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.awp;
	import com.vizar3d.ane.bullet.collision.dispatch.CollisionObject;
	import com.vizar3d.ane.bullet.dynamics.constraintsolver.TypedConstraint;
	
	import flash.geom.Vector3D;
	
	import awayphysics.dynamics.AWPDynamicsWorld;
	
	use namespace awp;
	
	public class DiscreteDynamicsWorld extends BulletBase
	{
		public static const BROADPHASE_DBVT: String = "dbvt";
		
		awp var awpDDWorld: AWPDynamicsWorld;
		
		public function DiscreteDynamicsWorld(broadphase:String=BROADPHASE_DBVT, scaling=0.01, expectNestedMeshes:Boolean=false) {
			awpDDWorld = AWPDynamicsWorld.getInstance();
			if (broadphase == BROADPHASE_DBVT) {
				awpDDWorld.initWithDbvtBroadphase();
			}
			awpDDWorld.scaling = 1.0/scaling;
			nestedMeshes = expectNestedMeshes;
		}
		
		// TODO: dispose
		
		public function addCollisionObject(obj:CollisionObject): void {
			awpDDWorld.addCollisionObject(obj.awpObject);
		}
		
		public function removeCollisionObject(obj:CollisionObject): void {
			awpDDWorld.removeCollisionObject(obj.awpObject);
		}
		
		public function addRigidBody(body:RigidBody): void {
			awpDDWorld.addRigidBody(body.awpBody);
		}
		
		public function removeRigidBody(body:RigidBody): void {
			awpDDWorld.removeRigidBody(body.awpBody);
		}
		
		public function addConstraint(constraint:TypedConstraint, disableCollisionsBetweenLinkedBodies:Boolean=false): void {
			awpDDWorld.addConstraint(constraint.awpTypedConst, disableCollisionsBetweenLinkedBodies);
		}
		
		public function removeConstraint(constraint:TypedConstraint): void {
			awpDDWorld.removeConstraint(constraint.awpTypedConst);
		}
		
		public function set gravity(grav:Vector3D): void {
			awpDDWorld.gravity = grav;
		}
		
		public function stepSimulation(timestep:Number, maxsubsteps:int=1, fixedstep:Number=1.0/60.0): void {
			awpDDWorld.step(timestep, maxsubsteps, fixedstep);
		}
	}
}