package ane.bulletphysics.dynamics
{
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.BulletBase;
	import ane.bulletphysics.awp;
	import ane.bulletphysics.collision.dispatch.CollisionObject;
	import ane.bulletphysics.dynamics.constraintsolver.TypedConstraint;
	
	import awayphysics.dynamics.AWPDynamicsWorld;
	
	use namespace awp;
	
	public class DiscreteDynamicsWorld extends BulletBase
	{
		public static const BROADPHASE_DBVT: String = "dbvt";
		
		awp var awpDDWorld: AWPDynamicsWorld;
		
		public function DiscreteDynamicsWorld(broadphase:String=BROADPHASE_DBVT, scaling:Number=0.01, expectNestedMeshes:Boolean=false) {
			awpDDWorld = AWPDynamicsWorld.getInstance();
			if (broadphase == BROADPHASE_DBVT) {
				awpDDWorld.initWithDbvtBroadphase();
			}
			awpDDWorld.scaling = 1.0/scaling;
			nestedMeshes = expectNestedMeshes;
			_scaling = scaling;
		}
		
		// TODO: dispose
		
		public function addCollisionObject(obj:CollisionObject, group:int=1, mask:int=-1): void {
			awpDDWorld.addCollisionObject(obj.awpObject, group, mask);
			obj.awp::collisionFilterGroup = group;
			obj.awp::collisionFilterMask = mask;
		}
		
		public function removeCollisionObject(obj:CollisionObject): void {
			awpDDWorld.removeCollisionObject(obj.awpObject);
		}
		
		public function addRigidBody(body:RigidBody, group:int=1, mask:int=-1): void {
			awpDDWorld.addRigidBodyWithGroup(body.awpBody, group, mask);
			body.awp::collisionFilterGroup = group;
			body.awp::collisionFilterMask = mask;
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
		
		/**
		 * Set acceleration due to gravity in units of meters per squared second.  Note that this is not
		 * equivalent to visual units per squared second unless you set 'scaling' to 1.0 in the
		 * DiscreteDynamicsWorld constructor.
		 */
		public function set gravity(grav:Vector3D): void {
			// annoyingly, this call also sets all nonstaticRigidBodies in the world's gravity too,
			// a behavior that is different from both Bullet itself and the ANE wrapper of Bullet.
			awpDDWorld.gravity = grav;
		}
		
		public function get gravity(): Vector3D {
			return awpDDWorld.gravity;
		}
		
		public function get scaling(): Number {
			return _scaling;
		}
		
		public function stepSimulation(timestep:Number, maxsubsteps:int=1, fixedstep:Number=1.0/60.0): void {
			awpDDWorld.step(timestep, maxsubsteps, fixedstep);
		}
	}
}