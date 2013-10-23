package ane.bulletphysics.collision.dispatch
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.BulletBase;
	import ane.bulletphysics.awp;
	import ane.bulletphysics.collision.shapes.CollisionShape;
	import ane.bulletphysics.dynamics.NestableAWPRigidBody;
	
	import away3d.containers.ObjectContainer3D;
	
	import awayphysics.collision.dispatch.AWPCollisionObject;
	
	use namespace awp;
	
	public class CollisionObject extends BulletBase
	{
		awp var awpObject: AWPCollisionObject;
		
		awp var collisionFilterGroup: int;
		awp var collisionFilterMask: int;
		
		public function CollisionObject(shape:CollisionShape, skin:ObjectContainer3D, subRigidBody:NestableAWPRigidBody=null) {
			awpObject = subRigidBody ? subRigidBody : new NestableAWPCollisionObject(shape.awpShape, skin, nestedMeshes);
		}
		
		public function get skin(): ObjectContainer3D {
			return awpObject.skin;
		}
		
		public function get worldTransform(): Matrix3D {
			return awpObject.transform;
		}
		
		public function set worldTransform(val:Matrix3D): void {
			awpObject.transform = val;
		}
		
		public function get position(): Vector3D {
			return awpObject.position;
		}
		
		public function set position(val:Vector3D): void {
			awpObject.position = val;
		}
		
		public function get collisionFlags(): int {
			return awpObject.collisionFlags;
		}
		
		public function set collisionFlags(flags:int): void {
			awpObject.collisionFlags = flags;
		}
		
		public function activate(forceActivation:Boolean=false): void {
			awpObject.activate(forceActivation);
		}
		
		public function get friction(): Number {
			return awpObject.friction;
		}
		
		public function set friction(val:Number): void {
			awpObject.friction = val;
		}
		
		public function get rollingFriction(): Number {
			return awpObject.rollingFriction;
		}
		
		public function set rollingFriction(val:Number): void {
			awpObject.rollingFriction = val;
		}
		
		public function get restitution(): Number {
			return awpObject.restitution;
		}
		
		public function set restitution(val:Number): void {
			awpObject.restitution = val;
		}
		
		public function get hitFraction(): Number {
			return awpObject.hitFraction;
		}
		
		public function set hitFraction(val:Number): void {
			awpObject.hitFraction = val;
		}
		
		public function get collisionFilterGroup(): int {
			return awp::collisionFilterGroup;
		}
		
		public function get collisionFilterMask(): int {
			return awp::collisionFilterMask;
		}
		
		public function set ccdSweptSphereRadius(val:Number): void {
			awpObject.ccdSweptSphereRadius = val;
		}
		
		public function set ccdMotionThreshold(val:Number): void {
			awpObject.ccdMotionThreshold = val;
		}
	}
}
