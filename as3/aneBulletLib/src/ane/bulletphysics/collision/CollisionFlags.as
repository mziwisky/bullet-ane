package ane.bulletphysics.collision
{
	public class CollisionFlags
	{
		public static const STATIC_OBJECT: int = 1;
		public static const KINEMATIC_OBJECT: int = 2;
		public static const NO_CONTACT_RESPONSE: int = 4;
		public static const CUSTOM_MATERIAL_CALLBACK: int = 8;
		public static const CHARACTER_OBJECT: int = 16;
		public static const DISABLE_VISUALIZE_OBJECT: int = 32;
		public static const DISABLE_SPU_COLLISION_PROCESSING: int = 64;
	}
}