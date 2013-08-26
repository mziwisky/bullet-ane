package ane.bulletphysics.dynamics
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.awp;
	import ane.bulletphysics.collision.dispatch.CollisionObject;
	import ane.bulletphysics.collision.shapes.CollisionShape;
	import ane.bulletphysics.dynamics.constraintsolver.TypedConstraint;
	
	import away3d.containers.ObjectContainer3D;
	
	import awayphysics.math.AWPMatrix3x3;
	
	use namespace awp;
	
	public class RigidBody extends CollisionObject
	{
		awp var awpBody: NestableAWPRigidBody;
		private const _constraintRefs: Vector.<TypedConstraint> = new Vector.<TypedConstraint>();
		
		public function RigidBody(shape:CollisionShape, skin:ObjectContainer3D, mass:Number, inertia:Vector3D=null) {
			awpBody = new NestableAWPRigidBody(shape.awpShape, skin, mass, nestedMeshes);
			super(shape, skin, awpBody);
			if (inertia) setMassProps(mass, inertia);
		}
		
		public function get mass(): Number {
			return awpBody.mass;
		}
		
		public function set mass(val:Number): void {
			awpBody.mass = val;
		}
		
		public function setMassProps(mass:Number, inertia:Vector3D=null): void {
			awpBody.mass = mass;
			if (inertia) {
				inertia = inertia.clone();
				inertia.scaleBy(_scaling);
				awpBody.invInertiaLocal = new Vector3D(
					inertia.x ? 1.0 / inertia.x : 0.0,
					inertia.y ? 1.0 / inertia.y : 0.0,
					inertia.z ? 1.0 / inertia.z : 0.0);
				// manually replicate updateInertialTransform(), in a very hacky brittle way :/
				// Note that the constant 260 below is subject to change.  If you update AwayPhysics, you'd do well
				// to confirm that this is still the correct pointer offset.
				// Note also that the following mess is not well tested, and may very well be wrong.  Sorry about that.
				var invInertiaTensorWorld: AWPMatrix3x3 = new AWPMatrix3x3(awpBody.pointer + 260);
				// Native method: m_invInertiaTensorWorld = m_worldTransform.getBasis().scaled(m_invInertiaLocal) * m_worldTransform.getBasis().transpose();
				var worldTransBasis: Matrix3D = awpBody.worldTransform.basis.m3d.clone();
				var worldTransBasisTranspose: Matrix3D = worldTransBasis.clone();
				worldTransBasisTranspose.transpose();
				var scaler: Matrix3D = new Matrix3D(new <Number>[
					awpBody.invInertiaLocal.x, 0, 0, 0,
					0, awpBody.invInertiaLocal.y, 0, 0,
					0, 0, awpBody.invInertiaLocal.z, 0,
					0, 0, 0, 1]);
				var invInert: Matrix3D = worldTransBasis;
				invInert.prepend(scaler);
				invInert.prepend(worldTransBasisTranspose);
				invInertiaTensorWorld.m3d = invInert;
			}
		}
		
		public function get inertia(): Vector3D {
			var invInert: Vector3D = awpBody.invInertiaLocal;
			var inert: Vector3D = new Vector3D(
				invInert.x ? 1.0 / invInert.x : 0.0,
				invInert.y ? 1.0 / invInert.y : 0.0,
				invInert.z ? 1.0 / invInert.z : 0.0);
			inert.scaleBy(1.0 / _scaling);
			return inert;
		}
		
		public function get linearFactor(): Vector3D {
			return awpBody.linearFactor;
		}
		
		public function set linearFactor(val:Vector3D): void {
			awpBody.linearFactor = val;
		}
		
		public function get angularFactor(): Vector3D {
			return awpBody.angularFactor;
		}
		
		public function set angularFactor(val:Vector3D): void {
			awpBody.angularFactor = val;
		}
		
		public function applyCentralImpulse(impulse:Vector3D): void {
			awpBody.applyCentralImpulse(impulse);
		}
		
		public function get linearVelocity(): Vector3D {
			return awpBody.linearVelocity;
		}
		
		public function set linearVelocity(val:Vector3D): void {
			awpBody.linearVelocity = val;
		}
		
		public function get angularVelocity(): Vector3D {
			return awpBody.angularVelocity;
		}
		
		public function set angularVelocity(val:Vector3D): void {
			awpBody.angularVelocity = val;
		}
		
		public function applyCentralForce(force:Vector3D): void {
			awpBody.applyCentralForce(force);
		}
		
		public function applyTorque(torque:Vector3D): void {
			awpBody.applyTorque(torque);
		}
		
		public function applyTorqueImpulse(timpulse:Vector3D): void {
			awpBody.applyTorqueImpulse(timpulse);
		}
		
		public function addConstraintRef(constraint:TypedConstraint): void {
			if (_constraintRefs.indexOf(constraint) == -1) {
				_constraintRefs.push(constraint);
			}
		}
		
		public function removeConstraintRef(constraint:TypedConstraint): void {
			var index:int = _constraintRefs.indexOf(constraint);
			if (index > -1) {
				_constraintRefs.splice(index, 1);
			}
		}
		
		public function getConstraintRef(index:int): TypedConstraint {
			return _constraintRefs.length > index ? _constraintRefs[index] : null;
		}
		
		public function getNumConstraintRefs(): int {
			return _constraintRefs.length;
		}
	}
}
