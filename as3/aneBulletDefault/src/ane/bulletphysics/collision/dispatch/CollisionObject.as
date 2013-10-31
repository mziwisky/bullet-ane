package ane.bulletphysics.collision.dispatch
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import ane.bulletphysics.BulletBase;
	import ane.bulletphysics.awp;
	import ane.bulletphysics.collision.shapes.CollisionShape;
	import ane.bulletphysics.dynamics.NestableAWPRigidBody;
	import ane.bulletphysics.events.BulletEvent;
	
	import away3d.containers.ObjectContainer3D;
	
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.events.AWPEvent;
	
	use namespace awp;
	
	public class CollisionObject extends BulletBase implements IEventDispatcher
	{
		awp var awpObject: AWPCollisionObject;
		
		awp var collisionFilterGroup: int;
		awp var collisionFilterMask: int;
		awp var parentWorld: CollisionWorld;
		private var _dispatcher: EventDispatcher;
		
		public function CollisionObject(shape:CollisionShape, skin:ObjectContainer3D, subRigidBody:NestableAWPRigidBody=null) {
			awpObject = subRigidBody ? subRigidBody : new NestableAWPCollisionObject(shape.awpShape, skin, nestedMeshes);
			_dispatcher = new EventDispatcher(this);
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
		
		private var listenerDict: Dictionary;
		
		private function eventTypeToAWP(type:String): String {
			switch (type) {
				case BulletEvent.COLLIDING: type = AWPEvent.COLLISION_ADDED; break;
				default: trace("WARNING: Event type \"" + type + "\" not supported."); break;
			}
			return type;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false): void {
			listenerDict ||= new Dictionary(true);
			const awpType: String = eventTypeToAWP(type);
			
			// Note: must add listener here (instead of making it a private instance method)
			// so I get a new instance of it every time this funciton is called.
			const proxy: Function = function(e:AWPEvent): void {
				var obj: CollisionObject = parentWorld.collisionObjects[e.collisionObject];
				switch (e.type) {
					case AWPEvent.COLLISION_ADDED:
						_dispatcher.dispatchEvent(new BulletEvent(BulletEvent.COLLIDING, obj));
						break;
					default:
						break;
				}
			}
			listenerDict[listener] = proxy;
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			awpObject.addEventListener(awpType, proxy, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(evt:Event): Boolean {
			// TODO: some translation here? Maybe turn the BulletEvent into an AWPEvent
			// and dispatch it thru the awpObject/awpRigidBody?
//			return awpRigidBody ? awpRigidBody.dispatchEvent(evt) : awpObject.dispatchEvent(evt);
			throw new Error("Haven't thought about how to implement this dispatch yet...");
			return false;
		}
		
		public function hasEventListener(type:String): Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false): void {
			const awpType: String = eventTypeToAWP(type);
			const proxy: Function = listenerDict[listener];
			_dispatcher.removeEventListener(type, listener, useCapture);
			awpObject.removeEventListener(awpType, proxy, useCapture);
		}
		
		public function willTrigger(type:String): Boolean {
			return _dispatcher.willTrigger(type);
		}

	}
}
