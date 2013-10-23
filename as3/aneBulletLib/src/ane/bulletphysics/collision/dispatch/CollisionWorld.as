package ane.bulletphysics.collision.dispatch
{
	import flash.utils.Dictionary;
	
	import ane.bulletphysics.BulletBase;
	
	public class CollisionWorld extends BulletBase
	{
		public static const BROADPHASE_DBVT: String = "dbvt";
		
		protected var collisionObjects: Dictionary;
		
		public function CollisionWorld(broadphase:String=BROADPHASE_DBVT, pointer:uint=0)
		{
			if (pointer) {
				this.pointer = pointer;
			} else {
				switch (broadphase) {
					case BROADPHASE_DBVT:
						this.pointer = extContext.call("createCollisionWorldWithDbvt") as uint;
						break;
					default:
						trace("WARNING: broadphase \"" + broadphase + "\" not recognized. Defaulting to DBVT.");
						this.pointer = extContext.call("createCollisionWorldWithDbvt") as uint;
						break;
				}
			}
			collisionObjects = new Dictionary(true);
		}
		
		public function addCollisionObject(obj:CollisionObject, group:int=1, mask:int=-1):void {
			if(!collisionObjects.hasOwnProperty(obj.pointer.toString())){
				collisionObjects[obj.pointer.toString()] = obj;
				extContext.call("CollisionWorld::addCollisionObject", pointer, obj.pointer, group, mask);
			}
		}
		
		public function removeCollisionObject(obj:CollisionObject, cleanup:Boolean=false) : void {			
			if(collisionObjects.hasOwnProperty(obj.pointer.toString())){
				delete collisionObjects[obj.pointer.toString()];
				extContext.call("CollisionWorld::removeCollisionObject", pointer, obj.pointer);
				
//				if (cleanup) {
//					obj.dispose();
//				}
			}
		}
		
		public function contactTest(obj:CollisionObject): Vector.<CollisionObject> {
			var ptrs: Vector.<uint> = extContext.call("CollisionWorld::contactTest", pointer, obj.pointer) as Vector.<uint>;
			if (!ptrs) return null;
			else {
				var hits: Vector.<CollisionObject> = new Vector.<CollisionObject>(ptrs.length, true);
				var i: int;
				for (i = 0; i < ptrs.length; i++) {
					hits[i] = collisionObjects[ptrs[i].toString()];
				}
				return hits;
			}
		}
	}
}