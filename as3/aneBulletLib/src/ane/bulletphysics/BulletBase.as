package ane.bulletphysics
{
	import flash.external.ExtensionContext;

	public class BulletBase
	{
		/**
		 * 1 visual unit equals _scaling Bullet units.
		 * Away3D uses centimeters by convention, and Bullet uses meters, so the default _scaling is 0.01
		 * refer to http://www.bulletphysics.org/mediawiki-1.5.8/index.php?title=Scaling_The_World
		 */
		protected static var _scaling : Number = 0.01;
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