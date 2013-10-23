package ane.bulletphysics.dynamics
{
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.awp;
	import ane.bulletphysics.collision.dispatch.CollisionWorld;
	import ane.bulletphysics.dynamics.constraintsolver.TypedConstraint;
	
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	use namespace awp;
	
	public class DiscreteDynamicsWorld extends CollisionWorld
	{	
		awp var awpDDWorld: AWPDynamicsWorld;
		
		public function DiscreteDynamicsWorld(broadphase:String=BROADPHASE_DBVT, scaling:Number=100, expectNestedMeshes:Boolean=false) {
			awpDDWorld = AWPDynamicsWorld.getInstance();
			if (broadphase == BROADPHASE_DBVT) {
				awpDDWorld.initWithDbvtBroadphase();
			}
			awpDDWorld.scaling = scaling;
			nestedMeshes = expectNestedMeshes;
			_scaling = scaling;
			super(broadphase, this);
		}
		
		// TODO: dispose
		
		public function addRigidBody(body:RigidBody, group:int=1, mask:int=-1): void {
			awpDDWorld.addRigidBodyWithGroup(body.awpBody, group, mask);
			body.awp::collisionFilterGroup = group;
			body.awp::collisionFilterMask = mask;
			collisionObjects[body.awpBody] = body;
		}
		
		public function removeRigidBody(body:RigidBody): void {
			awpDDWorld.removeRigidBody(body.awpBody);
			delete collisionObjects[body.awpBody];
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
			// Annoyingly, this call in AwayPhysics also sets the gravity of all nonstaticRigidBodies
			// in the world, a behavior that is different from both Bullet itself and the ANE wrapper.
			// So, I'll undo this behavior here.
			const bodies: Vector.<AWPRigidBody> = awpDDWorld.nonStaticRigidBodies;
			const gravities: Vector.<Vector3D> = new Vector.<Vector3D>(bodies.length, true);
			var i: int;
			for (i = 0; i < bodies.length; i++) {
				gravities[i] = bodies[i].gravity.clone();
			}
			
			awpDDWorld.gravity = grav;
			
			for (i = 0; i < bodies.length; i++) {
				bodies[i].gravity = gravities[i];
			}
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