package
{
	import com.vizar3d.ane.bullet.collision.shapes.BoxShape;
	import com.vizar3d.ane.bullet.collision.shapes.CapsuleShape;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	import com.vizar3d.ane.bullet.collision.shapes.CompoundShape;
	import com.vizar3d.ane.bullet.collision.shapes.ConeShape;
	import com.vizar3d.ane.bullet.collision.shapes.CylinderShape;
	import com.vizar3d.ane.bullet.collision.shapes.SphereShape;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.core.math.Quaternion;
	
	public function buildCompoundShape(desc:Array): CompoundShape {
		var cshape: CompoundShape = new CompoundShape();
		var shape: CollisionShape;
		var trans: Matrix3D = new Matrix3D();
		var q: Quaternion = new Quaternion();
		var pos: Vector3D = new Vector3D();
		
		for each (var obj:Object in desc) {
			var he: Array = obj.halfextents;
			var o: Array = obj.origin;
			var rot: Array = obj.rotate;
			var rad: Number = obj.radius;
			var ht: Number = obj.height;
			
			switch (obj.shape) {
				case "Box": shape = new BoxShape(he[0]*2, he[1]*2, he[2]*2);
					break;
				case "Cylinder": shape = new CylinderShape(rad, ht);
					break;
				case "Cone": shape = new ConeShape(rad, ht);
					break;
				case "Capsule": shape = new CapsuleShape(rad, ht);
					break;
				case "Sphere": shape = new SphereShape(rad);
					break;
				default: trace("Unknown physics shape: " + obj.shape);
					break;
			}
			
			if (rot) {
				q.x = rot[0]; q.y = rot[1]; q.z = rot[2]; q.w = rot[3];
			} else {
				q.x = q.y = q.z = 0; q.w = 1;
			}
			if (o) {
				pos.x = o[0]; pos.y = o[1]; pos.z = o[2];
			} else {
				pos.x = pos.y = pos.z = 0;
			}
			q.toMatrix3D(trans);
			trans.position = pos;
			cshape.addChildShape(shape, trans);
		}
		return cshape;
	}
}
