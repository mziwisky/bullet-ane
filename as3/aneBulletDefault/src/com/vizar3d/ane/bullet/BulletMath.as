package com.vizar3d.ane.bullet
{
	import flash.geom.Vector3D;

	public class BulletMath
	{
		private static const R2D: Number = 180.0/Math.PI;
		private static const D2R: Number = Math.PI/180.0;
		
		public static function rad2deg(rad:Number): Number {
			return rad * R2D;
		}
		
		public static function deg2rad(deg:Number): Number {
			return deg * D2R;
		}
		
		public static function v3d_rad2deg(rad:Vector3D, degOutput:Vector3D=null): Vector3D {
			return scaleVec(rad, R2D, degOutput);
		}
		
		public static function v3d_deg2rad(deg:Vector3D, radOutput:Vector3D=null): Vector3D {
			return scaleVec(deg, D2R, radOutput);
		}
		
		private static function scaleVec(input:Vector3D, scale:Number, output:Vector3D=null): Vector3D {
			if (output) output.copyFrom(input);
			else output = input.clone();
			output.scaleBy(scale);
			return output;
		}
	}
}