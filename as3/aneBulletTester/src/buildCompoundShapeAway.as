package
{
	import flash.geom.Vector3D;
	
	import away3d.core.math.Quaternion;
	
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPCapsuleShape;
	import awayphysics.collision.shapes.AWPCollisionShape;
	import awayphysics.collision.shapes.AWPCompoundShape;
	import awayphysics.collision.shapes.AWPConeShape;
	import awayphysics.collision.shapes.AWPCylinderShape;
	import awayphysics.collision.shapes.AWPSphereShape;
	
	public function buildCompoundShapeAway(desc:Array): AWPCompoundShape {
		var cshape: AWPCompoundShape = new AWPCompoundShape();
		var shape: AWPCollisionShape;
		var q: Quaternion = new Quaternion();
		var pos: Vector3D;
		var eulers: Vector3D;
		
		for each (var obj:Object in desc) {
			var he: Array = obj.halfextents;
			var o: Array = obj.origin;
			var rot: Array = obj.rotate;
			var rad: Number = obj.radius;
			var ht: Number = obj.height;
			
			switch (obj.shape) {
				case "Box": shape = new AWPBoxShape(he[0]*2, he[1]*2, he[2]*2);
					break;
				case "Cylinder": shape = new AWPCylinderShape(rad, ht);
					break;
				case "Cone": shape = new AWPConeShape(rad, ht);
					break;
				case "Capsule": shape = new AWPCapsuleShape(rad, ht);
					break;
				case "Sphere": shape = new AWPSphereShape(rad);
					break;
				default: trace("Unknown physics shape: " + obj.shape);
					break;
			}
			
			if (rot) {
				q.w = rot[0]; q.x = rot[1]; q.y = rot[2]; q.z = rot[3];
			} else {
				q.w = 1; q.x = q.y = q.z = 0;
			}
			if (o) {
				pos = new Vector3D(o[0], o[1], o[2]);
			} else {
				pos = new Vector3D();
			}
			eulers = new Vector3D();
			q.toEulerAngles(eulers);
			eulers.scaleBy(180.0/Math.PI);
			cshape.addChildShape(shape, pos, eulers);
		}
		return cshape;
	}
}
