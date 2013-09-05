package ane.bulletphysics
{
	import flash.external.ExtensionContext;

	public class BulletBase
	{
		/**
		 * By default, Bullet assumes all units to be SI -- sizes and positions are meters, masses
		 * are kilograms, time is seconds.  Bullet Lib works best when moving objects are in the size
		 * range of 0.05 to 10.0 units (meters).
		 * Refer to http://www.bulletphysics.org/mediawiki-1.5.8/index.php?title=Scaling_The_World
		 * 
		 * As a convenience, the DiscreteDynamicsWorld constructor takes a `scaling` parameter, and the
		 * ANE multiplies all user-specified positions and sizes by (1/scaling) before it passes those
		 * values to the Bullet library.
		 * 
		 * Therefore, 1 Bullet unit equals `scaling` visual (Away3D) units.
		 * 
		 * The default _scaling is 100.  So by default, the ANE will work best when moving objects are
		 * created with a size in the range of 5 to 1000.
		 * 
		 * Note that ONLY sizes and positions get scaled.  In spite of what the referred wiki page suggests,
		 * we don't scale velocities, torques, etc.  So a scaling of 100 can be interpreted as follows.
		 * All positions and sizes (both input to and output from the ANE) are in centimeters, but all
		 * other units remain SI.  Therefore velocities are m/s (not cm/s), accelerations -- in particular
		 * acceleration due to gravity -- are m/s^2, forces are Newtons, torques are Newton-meters, etc.
		 * Note that this agrees with the convention that AwayPhysics uses (i.e., only scaling distances
		 * and sizes).
		 */
		protected static var _scaling : Number = 100;
		private static var _extContext: ExtensionContext;
		public var pointer: uint;
		protected static var nestedMeshes: Boolean;
		
		protected function get extContext(): ExtensionContext {
			if (!_extContext) {
				_extContext = ExtensionContext.createExtensionContext("ane.bulletphysics", null);
			}
			return _extContext;
		}
	}
}