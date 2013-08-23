package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.collision.dispatch.CollisionObject;
	import com.vizar3d.ane.bullet.dynamics.constraintsolver.TypedConstraint;
	
	import flash.geom.Vector3D;

	public class DiscreteDynamicsWorld extends BulletBase
	{
		public static const BROADPHASE_DBVT: String = "dbvt";
		
		private var nonstaticRigidBodies: Vector.<RigidBody> = new Vector.<RigidBody>();
		private var rigidBodies: Vector.<RigidBody> = new Vector.<RigidBody>();
		
		public function DiscreteDynamicsWorld(broadphase:String=BROADPHASE_DBVT, scaling=0.01, expectNestedMeshes:Boolean=false) {
			pointer = extContext.call("createDiscreteDynamicsWorldWithDbvt") as uint;
			if (scaling) _scaling = scaling;
			nestedMeshes = expectNestedMeshes;
		}
		
		// TODO: dispose
		
		public function addCollisionObject(obj:CollisionObject, group:int=1, mask:int=-1): void {
			extContext.call("DiscreteDynamicsWorld::addCollisionObject", pointer, obj.pointer, group, mask);
		}
		
		public function removeCollisionObject(obj:CollisionObject): void {
			extContext.call("DiscreteDynamicsWorld::removeCollisionObject", pointer, obj.pointer);
		}
		
		public function addRigidBody(body:RigidBody, group:int=1, mask:int=-1): void {
			if (rigidBodies.indexOf(body) != -1) {
				return;
			}
			extContext.call("DiscreteDynamicsWorld::addRigidBody", pointer, body.pointer, group, mask);
			rigidBodies.push(body);
			if (!(body.collisionFlags & (CollisionObject.STATIC_OBJECT | CollisionObject.KINEMATIC_OBJECT))) {
				nonstaticRigidBodies.push(body);
			}
		}
		
		public function removeRigidBody(body:RigidBody): void {
			var index: int = rigidBodies.indexOf(body);
			if (index == -1) {
				return;
			}
			rigidBodies.splice(index, 1);
			if ((index = nonstaticRigidBodies.indexOf(body)) != -1) {
				nonstaticRigidBodies.splice(index, 1);
			}
			extContext.call("DiscreteDynamicsWorld::removeRigidBody", pointer, body.pointer);
		}
		
		public function addConstraint(constraint:TypedConstraint, disableCollisionsBetweenLinkedBodies:Boolean=false): void {
			extContext.call("DiscreteDynamicsWorld::addConstraint", pointer, constraint.pointer, disableCollisionsBetweenLinkedBodies);
		}
		
		public function removeConstraint(constraint:TypedConstraint): void {
			extContext.call("DiscreteDynamicsWorld::removeConstraint", pointer, constraint.pointer);
		}
		
		public function set gravity(grav:Vector3D): void {
			var scaledGrav:Vector3D = grav.clone();
			scaledGrav.scaleBy(_scaling);
			extContext.call("DiscreteDynamicsWorld::setGravity", pointer, scaledGrav);
		}
		
		public function stepSimulation(timestep:Number, maxsubsteps:int=1, fixedstep:Number=1.0/60.0): void {
			extContext.call("DiscreteDynamicsWorld::stepSimulation", pointer, timestep, maxsubsteps, fixedstep);
			
			var i: int = nonstaticRigidBodies.length;
			while (i--) {
				nonstaticRigidBodies[i].updateSkinTransform();
			}
		}
	}
}