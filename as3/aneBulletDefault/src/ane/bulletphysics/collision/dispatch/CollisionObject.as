package ane.bulletphysics.collision.dispatch
{
	import ane.bulletphysics.BulletBase;
	import ane.bulletphysics.awp;
	import ane.bulletphysics.collision.shapes.CollisionShape;
	import ane.bulletphysics.dynamics.NestableAWPRigidBody;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	
	use namespace awp;
	
	public class CollisionObject extends BulletBase
	{
		// Must ensure that the wrapped object is of the correct type (either AWPCollisionObject
		// or AWPRigidBody), but ALSO must subclass each of those AWP classes to override
		// the updateTransform() method to support nested meshes.  So I explicitly wrap only
		// one type of nestable class or the other.
		// I don't love this solution, but it's all I can think of.
		awp var awpObject: NestableAWPCollisionObject;
		awp var awpRigidBody: NestableAWPRigidBody;
		
		awp var collisionFilterGroup: int;
		awp var collisionFilterMask: int;
		
		public function CollisionObject(shape:CollisionShape, skin:ObjectContainer3D, subRigidBody:NestableAWPRigidBody=null) {
			if (subRigidBody) {
				awpRigidBody = subRigidBody;
			} else {
				awpObject = new NestableAWPCollisionObject(shape.awpShape, skin, nestedMeshes);
			}
		}
		
		public function get skin(): ObjectContainer3D {
			return awpRigidBody ? awpRigidBody.skin : awpObject.skin;
		}
		
		public function get worldTransform(): Matrix3D {
			return awpRigidBody ? awpRigidBody.transform : awpObject.transform;
		}
		
		public function set worldTransform(val:Matrix3D): void {
			awpRigidBody ? awpRigidBody.transform = val : awpObject.transform = val;
		}
		
		public function get position(): Vector3D {
			return awpRigidBody ? awpRigidBody.position : awpObject.position;
		}
		
		public function set position(val:Vector3D): void {
			awpRigidBody ? awpRigidBody.position = val : awpObject.position = val;
		}
		
		public function get collisionFlags(): int {
			return awpRigidBody ? awpRigidBody.collisionFlags : awpObject.collisionFlags;
		}
		
		public function set collisionFlags(flags:int): void {
			awpRigidBody ? awpRigidBody.collisionFlags = flags : awpObject.collisionFlags = flags;
		}
		
		public function activate(forceActivation:Boolean=false): void {
			awpRigidBody ? awpRigidBody.activate(forceActivation) : awpObject.activate(forceActivation);
		}
		
		public function get friction(): Number {
			return awpRigidBody ? awpRigidBody.friction : awpObject.friction;
		}
		
		public function set friction(val:Number): void {
			awpRigidBody ? awpRigidBody.friction = val : awpObject.friction = val;
		}
		
		public function get rollingFriction(): Number {
			return awpRigidBody ? awpRigidBody.rollingFriction : awpObject.rollingFriction;
		}
		
		public function set rollingFriction(val:Number): void {
			awpRigidBody ? awpRigidBody.rollingFriction = val : awpObject.rollingFriction = val;
		}
		
		public function get restitution(): Number {
			return awpRigidBody ? awpRigidBody.restitution : awpObject.restitution;
		}
		
		public function set restitution(val:Number): void {
			awpRigidBody ? awpRigidBody.restitution = val : awpObject.restitution = val;
		}
		
		public function get hitFraction(): Number {
			return awpRigidBody ? awpRigidBody.hitFraction : awpObject.hitFraction;
		}
		
		public function set hitFraction(val:Number): void {
			awpRigidBody ? awpRigidBody.hitFraction = val : awpObject.hitFraction = val;
		}
		
		public function get collisionFilterGroup(): int {
			return awp::collisionFilterGroup;
		}
		
		public function get collisionFilterMask(): int {
			return awp::collisionFilterMask;
		}
		
		public function set ccdSweptSphereRadius(val:Number): void {
			awpRigidBody ? awpRigidBody.ccdSweptSphereRadius = val : awpObject.ccdSweptSphereRadius = val;
		}
		
		public function set ccdMotionThreshold(val:Number): void {
			awpRigidBody ? awpRigidBody.ccdMotionThreshold = val : awpObject.ccdMotionThreshold = val;
		}
	}
}
