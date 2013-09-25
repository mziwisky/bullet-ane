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
			var awpObj: AWPCollisionObject = obj.awpRigidBody ? obj.awpRigidBody : obj.awpObject;
			awpWorld.addCollisionObject(awpObj, group, mask);
			obj.awp::collisionFilterGroup = group;
			obj.awp::collisionFilterMask = mask;
			
			collisionObjects[awpObj] = obj;
		}
		
		public function removeCollisionObject(obj:CollisionObject, cleanup:Boolean=false) : void {
			var awpObj: AWPCollisionObject = obj.awpRigidBody ? obj.awpRigidBody : obj.awpObject;
			awpWorld.removeCollisionObject(awpObj);
			
			delete collisionObjects[awpObj];
		}
		
		public function contactTest(obj:CollisionObject): Vector.<CollisionObject> {
			var awpObj: AWPCollisionObject = obj.awpRigidBody ? obj.awpRigidBody : obj.awpObject;
			var hits: Vector.<AWPCollisionObject> = awpWorld.contactTest(awpObj);
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