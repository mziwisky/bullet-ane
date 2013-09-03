package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.math.Plane3D;
	import away3d.core.math.Quaternion;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.events.LoaderEvent;
	import away3d.events.MouseEvent3D;
	import away3d.library.AssetLibrary;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.AWDParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.collision.shapes.AWPCollisionShape;
	import awayphysics.collision.shapes.AWPCompoundShape;
	import awayphysics.collision.shapes.AWPConeShape;
	import awayphysics.collision.shapes.AWPCylinderShape;
	import awayphysics.data.AWPCollisionFlags;
	import awayphysics.debug.AWPDebugDraw;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	import awayphysics.dynamics.constraintsolver.AWPGeneric6DofConstraint;
	import awayphysics.math.AWPMath;
	
	public class AwayBangStuffTogetherTest extends Sprite
	{
//		[Embed(source="/Users/mziwisky/models/turbosquid_2013-06-22/Dining Table/mike/table/table.awd",mimeType="application/octet-stream")]
		private var TableAWD:Class;
		
//		[Embed(source="/Users/mziwisky/models/turbosquid_2013-06-22/Dining Table/mike/chair/chair.awd",mimeType="application/octet-stream")]
//		private var ChairAWD:Class;
		
		[Embed(source="/Users/mziwisky/repos/vizar-market/src/assets/models/tcs/leatherSofa/sofa.awd",mimeType="application/octet-stream")]
		private var ChairAWD:Class;
		private var CouchShape:String = 
'\
{"physicsShape": [\
 {"shape": "Box", "origin": [-1.09598,21.082,5.26067], "halfextents": [94.168,21.082,48.9915]},\
 {"shape": "Box", "origin": [-1.09598,66.1373,35.54], "halfextents": [94.168,31.0236,17.1882]},\
 {"shape": "Cylinder", "origin": [-96.5141,50.3248,4.85376], "rotate": [-0.707107,0.707107,0,0], "height": 96.68256378173828, "radius": 8.752840042114258},\
 {"shape": "Cylinder", "origin": [93.5559,50.3248,4.85376], "rotate": [-0.707107,0.707107,0,0], "height": 96.68256378173828, "radius": 8.752840042114258}\
]}';
		
		private var ground: Mesh;
		private var table: ObjectContainer3D;
		private var chair: ObjectContainer3D;
		private var tableRB: AWPRigidBody;
		private var chairRB: AWPRigidBody;
		
		private var _view : View3D;
		private var _light : PointLight;
		private var lightPicker:StaticLightPicker;
		private var physicsWorld : AWPDynamicsWorld;
		private var timeStep : Number = 1.0 / 60;
		private var debugDraw:AWPDebugDraw;
		
		public function AwayBangStuffTogetherTest()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_view = new View3D();
			this.addChild(_view);
			this.addChild(new AwayStats(_view));
			
			_light = new PointLight();
			_light.y = 300;
			_light.z = -500;
			_view.scene.addChild(_light);
			
			lightPicker = new StaticLightPicker([_light]);
			
			_view.camera.lens.far = 10000;
			_view.camera.y = _light.y;
			_view.camera.z = _light.z;
			_view.camera.rotationX = 25;
			
			// init the physics world
			physicsWorld = AWPDynamicsWorld.getInstance();
			physicsWorld.initWithDbvtBroadphase();
			debugDraw = new AWPDebugDraw(_view, physicsWorld);
			debugDraw.debugMode |= 
				AWPDebugDraw.DBG_DrawConstraints | AWPDebugDraw.DBG_DrawConstraintLimits | 
//				AWPDebugDraw.DBG_DrawTransform |
				AWPDebugDraw.DBG_DrawCollisionShapes;

			// create ground mesh
			var material : ColorMaterial = new ColorMaterial(0x252525);
			material.lightPicker = lightPicker;
			ground = new Mesh(new PlaneGeometry(50000, 50000),material);
//			ground.mouseEnabled = true;
//			ground.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			_view.scene.addChild(ground);
			
			// create ground shape and rigidbody
//			var groundShape : StaticPlaneShape = new StaticPlaneShape(new Vector3D(0, 1, 0), 0);
//			var groundRigidbody : RigidBody = new RigidBody(groundShape, ground, 0);
//			physicsWorld.addRigidBody(groundRigidbody);
			
			// create a wall
			var wall : Mesh = new Mesh(new CubeGeometry(20000, 5000, 100), material);
			_view.scene.addChild(wall);
			
			var wallShape : AWPBoxShape = new AWPBoxShape(20000, 5000, 100);
			var wallRigidbody : AWPRigidBody = new AWPRigidBody(wallShape, wall, 0);
			physicsWorld.addRigidBody(wallRigidbody);
			
			wallRigidbody.position = new Vector3D(0, 2500, 2000);
			
			// add furniture to scene
			loadFurnitureToScene();
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		private function loadFurnitureToScene(): void {
			Loader3D.enableParser(AWDParser);
			// Table first
			AssetLibrary.loadData(new TableAWD(), null, null, new AWDParser());
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, tableLoaded);
			AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, assetComplete);
		}
		
		private function tableLoaded(e:LoaderEvent): void {
			AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, tableLoaded);
			trace("loaded target: " + e.target + " currentTarget: " + e.currentTarget);
			table = AssetLibrary.getAsset("cont") as ObjectContainer3D;
			prepOC3D(table);
			
//			tableRB = new AWPRigidBody(createTableShape(), null, 0);
//			tableRB.x = -100;
//			tableRB.z = -200;
//			physicsWorld.addRigidBody(tableRB);
//			
//			tableRB = new AWPRigidBody(createTableShape(), null, 0);
//			tableRB.x = -100;
//			tableRB.z = 200;
//			physicsWorld.addRigidBody(tableRB);
			
			tableRB = new AWPRigidBody(createTableShape(), table, 0);
			tableRB.x = -100;
			physicsWorld.addRigidBody(tableRB);
			
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, chairLoaded);
			AssetLibrary.loadData(new ChairAWD(), null, null, new AWDParser());
		}
		
		private function chairLoaded(e:LoaderEvent): void {
			AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, chairLoaded);
			chair = AssetLibrary.getAsset("cont") as ObjectContainer3D;
			prepOC3D(chair);
			
//			chairRB = new AWPRigidBody(createChairShape(), chair, 10);
			var shape: AWPCollisionShape = buildCompoundShapeAway(JSON.parse(CouchShape).physicsShape);
			chairRB = new AWPRigidBody(shape, chair, 10);
			chairRB.x = 100;
			physicsWorld.addRigidBody(chairRB);
			
//			applyFactorConstraint(chairRB);
//			apply6DofConstraint(chairRB);
			applyPlaneConstraint(new Plane3D(0.3,1,-.2,40), chairRB);
			
			ground.mouseEnabled = true;
			ground.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			ground.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			ground.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
		}
		
		private function applyPlaneConstraint(plane:Plane3D, body:AWPRigidBody): void {
			// if the constraint body exists, use it. else, create it.
			planeConstraintBody ||= new AWPRigidBody(new AWPBoxShape());
			planeConstraintBody.collisionFlags |= AWPCollisionFlags.CF_NO_CONTACT_RESPONSE;
			
			// create a new 6dof in which the constraint plane's normal is aligned with the Z-axis of its relative frame,
			// AND its relative frame is offset such that it rests on the plane,
			// and the body's Y-axis is aligned with the Z-axis of its relative frame
			var zeroVec: Vector3D = new Vector3D();
			var constFramePos: Vector3D = plane.intersects(zeroVec, Vector3D.Y_AXIS);
			if (!constFramePos) constFramePos = plane.intersects(zeroVec, Vector3D.Z_AXIS);
			if (!constFramePos) constFramePos = plane.intersects(zeroVec, Vector3D.X_AXIS);
			var constFrameRot: Vector3D = AWPMath.radians2degreesV3D(getEulerRotationThatAlignsZWithPlaneNormal(plane));
			var bodyFramePos: Vector3D = zeroVec;
			var bodyFrameRot: Vector3D = new Vector3D(-90, 0, 0);
			
			// TODO: transform body to conform with the constraint (so that the physicsWorld doesn't have to do it, and it isn't seen "relaxing" into place)
			
			var sixdof:AWPGeneric6DofConstraint = new AWPGeneric6DofConstraint(
				planeConstraintBody, constFramePos, constFrameRot, 
				body, bodyFramePos, bodyFrameRot, true);
			
			sixdof.setLinearLimit(new Vector3D(1000, 1000, 0), new Vector3D(-1000, -1000, 0));
			sixdof.setAngularLimit(new Vector3D(0, 0, 1000), new Vector3D(0, 0, -1000));
			
			physicsWorld.addConstraint(sixdof, true);
		}
		
		private function getEulerRotationThatAlignsZWithPlaneNormal(plane:Plane3D): Vector3D {
			// First, Z x N will give a rotation axis
			var N: Vector3D = new Vector3D(plane.a, plane.b, plane.c);
			N.normalize();
			var rotAxis: Vector3D = Vector3D.Z_AXIS.crossProduct(N);
			if (!rotAxis.length) {
				return rotAxis;
			}
			rotAxis.normalize();
			var angle: Number = Math.acos(N.z);
			// Now, turn that axis+angle into Euler angles
			var m: Matrix3D = new Matrix3D();
			var q: Quaternion = new Quaternion();
			q.fromAxisAngle(rotAxis, angle);
			return q.toEulerAngles();
		}
		
		private function applyFactorConstraint(body: AWPRigidBody): void {
			body.linearFactor = new Vector3D(1, 0, 1);
			body.angularFactor = new Vector3D(0, 1, 0);
		}
		
		private var planeConstraintBody: AWPRigidBody;
		private function apply6DofConstraint(body: AWPRigidBody): void {
			planeConstraintBody ||= new AWPRigidBody(new AWPBoxShape());
			planeConstraintBody.collisionFlags |= AWPCollisionFlags.CF_NO_CONTACT_RESPONSE;
			
			var sixdof:AWPGeneric6DofConstraint = new AWPGeneric6DofConstraint(
				body, new Vector3D(0,0,0), new Vector3D(), 
				planeConstraintBody, new Vector3D(0, 0, 0), new Vector3D());
			sixdof.setLinearLimit(new Vector3D(1000, 0, 1000), new Vector3D(-1000, 0, -1000));
			sixdof.setAngularLimit(new Vector3D(0, 1000, 0), new Vector3D(0, -1000, 0));
//			sixdof.getTranslationalLimitMotor().enableMotorZ = true;
//			sixdof.getTranslationalLimitMotor().targetVelocity = new Vector3D(0, 0, 10);
//			sixdof.getTranslationalLimitMotor().maxMotorForce = new Vector3D(0, 0, 5);
			
			for (var i:int = 0; i < 3; i++) {
				sixdof.getRotationalLimitMotor(i).maxLimitForce = Number.MAX_VALUE;
				sixdof.getRotationalLimitMotor(i).stopERP = 1.0;
				sixdof.getRotationalLimitMotor(i).limitSoftness = 1.0;
			}
			
			physicsWorld.addConstraint(sixdof, true);
		}
		
		private function prepOC3D(oc:ObjectContainer3D): void {
			for (var i:int = 0; i < oc.numChildren; i++) {
				var m:Mesh = oc.getChildAt(i) as Mesh;
				if (m) {
					m.material.lightPicker = lightPicker;
				}
			}
			_view.scene.addChild(oc);
		}
		
		private function assetComplete(e:AssetEvent): void {
			trace("asset: " + e.asset + " name: \"" + e.asset.name + "\"");
		}
		
		private function createChairShape(): AWPCompoundShape {
			var shape: AWPCollisionShape;
			var transform: Matrix3D = new Matrix3D();
			
			var chairShape : AWPCompoundShape = new AWPCompoundShape();
			
			shape = new AWPBoxShape(2*23.287,2*24.8,2*23.7);
			chairShape.addChildShape(shape, new Vector3D(0,24.8,0.757404));
			
			shape = new AWPBoxShape(2*23.287,2*32.0834,2*3.78214);
			var q: Quaternion = new Quaternion(0.995005,-0.0998279,0,0);
			q.toMatrix3D(transform);
			var decom: Vector.<Vector3D> = transform.decompose();
			chairShape.addChildShape(shape, new Vector3D(0,74.6782,23.1813), decom[1]);
			
			return chairShape;
		}
		
		private function createTableShape(): AWPCompoundShape {
			var shape: AWPCollisionShape;
			var transform: Matrix3D = new Matrix3D();
			var tableShape: AWPCompoundShape = new AWPCompoundShape();
			
			shape = new AWPConeShape(9.0, 99.08800506591797);
			tableShape.addChildShape(shape, new Vector3D(23.5831,22.4468,36.6), new Vector3D(180,0,0));
			tableShape.addChildShape(shape, new Vector3D(-22.7995,22.4468,36.6074), new Vector3D(180,0,0));
			tableShape.addChildShape(shape, new Vector3D(-22.7995,22.4468,-37.4066), new Vector3D(180,0,0));
			tableShape.addChildShape(shape, new Vector3D(23.5831,22.4468,-37.404), new Vector3D(180,0,0));
			
			shape = new AWPCylinderShape(50.053,2*1.51707);
			tableShape.addChildShape(shape, new Vector3D(0,71.8862,0));
			shape = new AWPCylinderShape(36.244,2*1.51707);
			tableShape.addChildShape(shape, new Vector3D(0,71.8862,-38.2469));
			tableShape.addChildShape(shape, new Vector3D(0,71.8862,38.2469));
			shape = new AWPCylinderShape(45.857,2*1.51707);
			tableShape.addChildShape(shape, new Vector3D(0,71.8862,-21.6293));
			tableShape.addChildShape(shape, new Vector3D(0,71.8862,21.6293));
			
			
			return tableShape;
		}
		
		private function onResize(e: Event): void {
			_view.stage3DProxy.width = stage.stageWidth;
			_view.width = stage.stageWidth;
			_view.stage3DProxy.height = stage.stageHeight;
			_view.height = stage.stageHeight;
		}
		
		private var clickoffset: Vector3D;
		private var clickcurrent: Vector3D;
		private var dragging: Boolean = false;
		
		private function onMouseDown(e:MouseEvent3D): void {
			clickoffset = chairRB.position.subtract(e.localPosition);
			clickcurrent = e.localPosition;
			dragging = true;
		}
		
		private function onMouseMove(e:MouseEvent3D): void {
			clickcurrent = e.localPosition;
		}
		
		private function onMouseUp(e:MouseEvent3D): void {
			dragging = false;
		}
		
		private function updateChairForce(): void {
			if (!chairRB) return;
			chairRB.linearVelocity = new Vector3D();
//			chairRB.angularVelocity = new Vector3D();
			if (dragging) {
				var force: Vector3D = clickcurrent.add(clickoffset).subtract(chairRB.position);
				force.scaleBy(10);
				chairRB.applyCentralForce(force);
			}
		}
		
		private function updateChairLocation(): void {
			if (dragging) {
				var loc: Vector3D = clickcurrent.add(clickoffset);
				chairRB.position = loc;
			}
		}
		
		private function handleEnterFrame(e : Event) : void {
			if (chairRB) { trace("chairLoc: " + chairRB.position); }
			updateChairForce();
//			updateChairLocation();
			physicsWorld.step(timeStep);
			debugDraw.debugDrawWorld();
			_view.render();
		}
	}
}