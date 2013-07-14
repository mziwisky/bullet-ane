package com.vizar3d.ane.bullet
{
	public class BulletBase
	{
		public var pointer: uint;
		protected static function noSupport(): void {
			throw new Error("Bullet Physics ANE is not supported on this platform.  :'(");	
		}
		
		public function BulletBase() {
			noSupport();
		}
	}
}