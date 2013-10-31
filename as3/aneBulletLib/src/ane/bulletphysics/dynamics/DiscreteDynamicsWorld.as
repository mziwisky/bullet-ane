package ane.bulletphysics.dynamics
{
	import flash.events.StatusEvent;
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.collision.CollisionFlags;
	import ane.bulletphysics.collision.dispatch.CollisionObject;
	import ane.bulletphysics.collision.dispatch.CollisionWorld;
	import ane.bulletphysics.dynamics.constraintsolver.TypedConstraint;
	import ane.bulletphysics.events.BulletEvent;

	public class DiscreteDynamicsWorld extends CollisionWorld
	{	
		private var nonstaticRigidBodies: Vector.<RigidBody> = new Vector.<RigidBody>();
		private var rigidBodies: Vector.<RigidBody> = new Vector.<RigidBody>();
		private var _collisionCallbackOn: Boolean;
		
		public function DiscreteDynamicsWorld(broadphase:String=BROADPHASE_DBVT, scaling:Number=100, expectNestedMeshes:Boolean=false) {
			switch (broadphase) {
				case BROADPHASE_DBVT:
					pointer = extContext.call("createDiscreteDynamicsWorldWithDbvt") as uint;
					break;
				default:
					trace("WARNING: broadphase \"" + broadphase + "\" not recognized. Defaulting to DBVT.");
					pointer = extContext.call("createDiscreteDynamicsWorldWithDbvt") as uint;
					break;
			}
			if (scaling) _scaling = scaling;
			nestedMeshes = expectNestedMeshes;
			extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			super(broadphase, pointer);
		}
		
		// TODO: dispose
		
		public function addRigidBody(body:RigidBody, group:int=1, mask:int=-1): void {
			if (rigidBodies.indexOf(body) != -1) {
				return;
			}
			extContext.call("DiscreteDynamicsWorld::addRigidBody", pointer, body.pointer, group, mask);
			rigidBodies.push(body);
			if (!(body.collisionFlags & (CollisionFlags.STATIC_OBJECT | CollisionFlags.KINEMATIC_OBJECT))) {
				nonstaticRigidBodies.push(body);
			}
			if(!collisionObjects.hasOwnProperty(body.pointer.toString())){
				collisionObjects[body.pointer.toString()] = body;
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
			if(collisionObjects.hasOwnProperty(body.pointer.toString())) {
				delete collisionObjects[body.pointer.toString()];
			}
			extContext.call("DiscreteDynamicsWorld::removeRigidBody", pointer, body.pointer);
		}
		
		public function addConstraint(constraint:TypedConstraint, disableCollisionsBetweenLinkedBodies:Boolean=false): void {
			extContext.call("DiscreteDynamicsWorld::addConstraint", pointer, constraint.pointer, disableCollisionsBetweenLinkedBodies);
		}
		
		public function removeConstraint(constraint:TypedConstraint): void {
			extContext.call("DiscreteDynamicsWorld::removeConstraint", pointer, constraint.pointer);
		}
		
		/**
		 * Set acceleration due to gravity in units of meters per squared second.  Note that this is not
		 * equivalent to visual units per squared second unless you set 'scaling' to 1.0 in the
		 * DiscreteDynamicsWorld constructor.
		 */
		public function set gravity(grav:Vector3D): void {
			extContext.call("DiscreteDynamicsWorld::setGravity", pointer, grav);
		}
		
		public function get gravity(): Vector3D {
			return extContext.call("DiscreteDynamicsWorld::getGravity", pointer) as Vector3D;
		}
		
		public function get scaling(): Number {
			return _scaling;
		}
		
		public function get collisionCallbackOn(): Boolean {
			return _collisionCallbackOn;
		}
		
		public function set collisionCallbackOn(val:Boolean): void {
			if (_collisionCallbackOn == val) return;
			_collisionCallbackOn = val;
			extContext.call("DiscreteDynamicsWorld::setCollisionCallback", pointer, val);
		}
		
		private function onStatusEvent(e:StatusEvent): void {
			var objA: CollisionObject = collisionObjects[e.code];
			var objB: CollisionObject = collisionObjects[e.level];
			if (objA && objB) {
				objA.dispatchEvent(new BulletEvent(BulletEvent.COLLIDING, objB));
			}
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