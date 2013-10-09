package ane.bulletphysics.collision.dispatch
{
	import flash.utils.Dictionary;
	
	import ane.bulletphysics.BulletBase;
	import ane.bulletphysics.awp;
	import ane.bulletphysics.dynamics.DiscreteDynamicsWorld;
	
	import awayphysics.collision.dispatch.AWPCollisionObject;
	import awayphysics.collision.dispatch.AWPCollisionWorld;
	
	use namespace awp;
	
	public class CollisionWorld extends BulletBase
	{
		public static const BROADPHASE_DBVT: String = "dbvt";
		
		awp var awpWorld: AWPCollisionWorld;
		awp var collisionObjects: Dictionary;
		
		public function CollisionWorld(broadphase:String=BROADPHASE_DBVT, subDDW:DiscreteDynamicsWorld=null)
		{
			if (subDDW) awpWorld = subDDW.awpDDWorld;
			else {
				awpWorld = new AWPCollisionWorld();
				throw new Error("AwayPhysics doesn't actually support CollisionWorlds alone, only DiscreteDynamicsWorlds.");
			}
			collisionObjects = new Dictionary(true);
		}
		
		public function addCollisionObject(obj:CollisionObject, group:int=1, mask:int=-1):void{
			awpWorld.addCollisionObject(obj.awpObject, group, mask);
			obj.awp::collisionFilterGroup = group;
			obj.awp::collisionFilterMask = mask;
			
			collisionObjects[obj.awpObject] = obj;
		}
		
		public function removeCollisionObject(obj:CollisionObject, cleanup:Boolean=false) : void {
			awpWorld.removeCollisionObject(obj.awpObject);
			
			delete collisionObjects[obj.awpObject];
		}
		
		public function contactTest(obj:CollisionObject): Vector.<CollisionObject> {
			var hits: Vector.<AWPCollisionObject> = awpWorld.contactTest(obj.awpObject);
			if (!hits) return null;
			else {
				var realhits: Vector.<CollisionObject> = new Vector.<CollisionObject>(hits.length);
				for (var i:int=0; i < hits.length; i++) {
					realhits[i] = collisionObjects[hits[i]];
				}
				return realhits;
			}
		}
	}
}