package com.vizar3d.ane.bullet
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class BulletMath extends BulletBase
	{
		public static function scaleTransformA3DtoBullet(a3dTrans:Matrix3D): Matrix3D {
			return scaleMatrixPosition(a3dTrans, _scaling);
		}
		
		public static function scaleTransformBulletToA3D(btTrans:Matrix3D): Matrix3D {
			return scaleMatrixPosition(btTrans, 1/_scaling);
		}
		
		private static function scaleMatrixPosition(mat:Matrix3D, scale:Number): Matrix3D {
			const newMat: Matrix3D = mat.clone();
			const pos: Vector3D = mat.position;
			pos.scaleBy(scale);
			newMat.position = pos;
			return newMat;
		}
		
		public static function vectorComponentMultiply(v1:Vector3D, v2:Vector3D):Vector3D {
			return new Vector3D(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
		}
	}
}