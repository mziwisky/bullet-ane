package com.vizar3d.ane.bullet.dynamics
{
	import com.vizar3d.ane.bullet.BulletBase;
	import com.vizar3d.ane.bullet.collision.CollisionObject;

	public class DiscreteDynamicsWorld extends BulletBase
	{
		public static const BROADPHASE_DBVT: String = "dbvt";
		
		private var nonstaticRigidBodies: Vector.<RigidBody> = new Vector.<RigidBody>();
		private var rigidBodies: Vector.<RigidBody> = new Vector.<RigidBody>();
		
		public function DiscreteDynamicsWorld(broadphase:String=BROADPHASE_DBVT, scaling=0.01) {
			pointer = extContext.call("createDiscreteDynamicsWorldWithDbvt") as uint;
			if (scaling) _scaling = scaling;
		}
		
		// TODO: dispose
		
		public function addCollisionObject(obj:CollisionObject): void {
			extContext.call("DiscreteDynamicsWorld::addCollisionObject", pointer, obj.pointer);
		}
		
		public function removeCollisionObject(obj:CollisionObject): void {
			extContext.call("DiscreteDynamicsWorld::removeCollisionObject", pointer, obj.pointer);
		}
		
		public function addRigidBody(body:RigidBody): void {
			if (rigidBodies.indexOf(body) != -1) {
				return;
			}
			extContext.call("DiscreteDynamicsWorld::addRigidBody", pointer, body.pointer);
			rigidBodies.push(body);
			if (body.mass) { //TODO: eventually, CollisionObjects will have CollisionFlags -- use that instead
				nonstaticRigidBodies.push(body);
			}
		}
		
		public function removeRigidBody(body:RigidBody): void {
			extContext.call("DiscreteDynamicsWorld::removeRigidBody", pointer, body.pointer);
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