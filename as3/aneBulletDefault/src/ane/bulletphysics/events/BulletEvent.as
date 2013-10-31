package ane.bulletphysics.events
{
	import flash.events.Event;
	
	import ane.bulletphysics.collision.dispatch.CollisionObject;
	
	public class BulletEvent extends Event
	{
		/**
		 * Dispatched when an object is colliding with another object
		 */
		public static const COLLIDING : String = "colliding";
		
		/**
		 * The object that is colliding with the target object
		 */
		public var collisionObject : CollisionObject;
		
		public function BulletEvent(type:String, obj:CollisionObject=null)
		{
			super(type);
			this.collisionObject = obj;
		}
	}
}
