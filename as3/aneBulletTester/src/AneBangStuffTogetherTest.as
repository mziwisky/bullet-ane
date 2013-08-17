package
{
	import com.vizar3d.ane.bullet.collision.shapes.BoxShape;
	import com.vizar3d.ane.bullet.collision.shapes.CollisionShape;
	import com.vizar3d.ane.bullet.collision.shapes.CompoundShape;
	import com.vizar3d.ane.bullet.collision.shapes.ConeShape;
	import com.vizar3d.ane.bullet.collision.shapes.CylinderShape;
	import com.vizar3d.ane.bullet.dynamics.DiscreteDynamicsWorld;
	import com.vizar3d.ane.bullet.dynamics.RigidBody;
	import com.vizar3d.ane.bullet.dynamics.constraintsolver.Generic6DofConstraint;
	
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
	
	public class AneBangStuffTogetherTest extends Sprite
	{
		[Embed(source="/Users/mziwisky/models/turbosquid_2013-06-22/Dining Table/mike/table/table.awd",mimeType="application/octet-stream")]
		private var TableAWD:Class;
		
		[Embed(source="/Users/mziwisky/models/turbosquid_2013-06-22/Dining Table/mike/chair/chair.awd",mimeType="application/octet-stream")]
		private var ChairAWD:Class;
		
		private var ground: Mesh;
		private var table: ObjectContainer3D;
		private var chair: ObjectContainer3D;
		private var tableRB: RigidBody;
		private var chairRB: RigidBody;
		
		private var _view : View3D;
		private var _light : PointLight;
		private var lightPicker:StaticLightPicker;
		private var physicsWorld : DiscreteDynamicsWorld;
		private var timeStep : Number = 1.0 / 60;
		
		public function AneBangStuffTogetherTest()
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
			physicsWorld = new DiscreteDynamicsWorld();
			
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
			
			var wallShape : BoxShape = new BoxShape(20000, 5000, 100);
			var wallRigidbody : RigidBody = new RigidBody(wallShape, wall, 0);
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
//			table.x = -100;
			
//			tableRB = new RigidBody(createTableShape(), null, 0);
//			tableRB.position = new Vector3D(-100, 0, -200);
//			physicsWorld.addRigidBody(tableRB);
//			
//			tableRB = new RigidBody(createTableShape(), null, 0);
//			tableRB.position = new Vector3D(-100, 0, 200);
//			physicsWorld.addRigidBody(tableRB);
			
			tableRB = new RigidBody(createTableShape(), table, 0);
			tableRB.position = new Vector3D(-100, 0, 0);
			physicsWorld.addRigidBody(tableRB);
			
			AssetLibrary.addEventListener(LoaderEvent.RESOURCE_COMPLETE, chairLoaded);
			AssetLibrary.loadData(new ChairAWD(), null, null, new AWDParser());
		}
		
		private function chairLoaded(e:LoaderEvent): void {
			AssetLibrary.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, chairLoaded);
			chair = AssetLibrary.getAsset("cont") as ObjectContainer3D;
			prepOC3D(chair);
//			chair.x = 100;
			
			chairRB = new RigidBody(createChairShape(), chair, 1);
			chairRB.position = new Vector3D(100, 0, 0);
			physicsWorld.addRigidBody(chairRB);
			
//			applyPlaneConstraint(new Plane3D(0.3,1,-.2,40), chairRB);
			applyPlaneConstraint(new Plane3D(0,1,0,0), chairRB);
			
			ground.mouseEnabled = true;
			ground.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			ground.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			ground.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
		}
		
		private var planeConstraintBody: RigidBody;
		private function applyPlaneConstraint(plane:Plane3D, body:RigidBody): void {
			// if the constraint body exists, use it. else, create it.
			planeConstraintBody ||= new RigidBody(new BoxShape(), null, 0);
//			planeConstraintBody.collisionFlags |= CollisionFlags.CF_NO_CONTACT_RESPONSE;
			
			// create a new 6dof in which the constraint plane's normal is aligned with the Z-axis of its relative frame,
			// AND its relative frame is offset such that it rests on the plane,
			// and the body's Y-axis is aligned with the Z-axis of its relative frame
			var zeroVec: Vector3D = new Vector3D();
			var constFramePos: Vector3D = plane.intersects(zeroVec, Vector3D.Y_AXIS);
			if (!constFramePos) constFramePos = plane.intersects(zeroVec, Vector3D.Z_AXIS);
			if (!constFramePos) constFramePos = plane.intersects(zeroVec, Vector3D.X_AXIS);
			var constFrameRot: Vector3D = getEulerRotationThatAlignsZWithPlaneNormal(plane);
			var bodyFramePos: Vector3D = zeroVec;
			var bodyFrameRot: Vector3D = new Vector3D(-Math.PI/2, 0, 0);
			
			// TODO: transform body to conform with the constraint (so that the physicsWorld doesn't have to do it, and it isn't seen "relaxing" into place)
			
			var sixdof:Generic6DofConstraint = new Generic6DofConstraint(
				planeConstraintBody, constFramePos, constFrameRot, 
				body, bodyFramePos, bodyFrameRot, true);
			
			sixdof.setLinearLimits(new Vector3D(1000, 1000, 0), new Vector3D(-1000, -1000, 0));
			sixdof.setAngularLimits(new Vector3D(0, 0, 1000), new Vector3D(0, 0, -1000));
			
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
		
		private function createChairShape(): CompoundShape {
			var shape: CollisionShape;
			var transform: Matrix3D = new Matrix3D();
			
			var chairShape : CompoundShape = new CompoundShape();
			
			shape = new BoxShape(2*23.287,2*24.8,2*23.7);
			transform.position = new Vector3D(0,24.8,0.757404);
			chairShape.addChildShape(shape, transform);
			
			shape = new BoxShape(2*23.287,2*32.0834,2*3.78214);
			var q: Quaternion = new Quaternion(0.995005,-0.0998279,0,0);
			q.toMatrix3D(transform);
			transform.position = new Vector3D(0,74.6782,23.1813);
			chairShape.addChildShape(shape, transform);
			
			return chairShape;
		}
		
		private function createTableShape(): CompoundShape {
			var shape: CollisionShape;
			var transform: Matrix3D = new Matrix3D();
			var tableShape: CompoundShape = new CompoundShape();
			
			shape = new ConeShape(9.0, 99.08800506591797);
			var q: Quaternion = new Quaternion(0, 1, 0, 0);
			q.toMatrix3D(transform);
			transform.position = new Vector3D(23.5831,22.4468,36.6);
			tableShape.addChildShape(shape, transform);
			
			transform.position = new Vector3D(-22.7995,22.4468,36.6074);
			tableShape.addChildShape(shape, transform);
			
			transform.position = new Vector3D(-22.7995,22.4468,-37.4066);
			tableShape.addChildShape(shape, transform);
			
			transform.position = new Vector3D(23.5831,22.4468,-37.404);
			tableShape.addChildShape(shape, transform);
			
			shape = new CylinderShape(50.053,2*1.51707);
			transform.identity();
			transform.position = new Vector3D(0,71.8862,0);
			tableShape.addChildShape(shape, transform);
			shape = new CylinderShape(36.244,2*1.51707);
			transform.position = new Vector3D(0,71.8862,-38.2469);
			tableShape.addChildShape(shape, transform);
			transform.position = new Vector3D(0,71.8862,38.2469);
			tableShape.addChildShape(shape, transform);
			shape = new CylinderShape(45.857,2*1.51707);
			transform.position = new Vector3D(0,71.8862,-21.6293);
			tableShape.addChildShape(shape, transform);
			transform.position = new Vector3D(0,71.8862,21.6293);
			tableShape.addChildShape(shape, transform);
			
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
			if (dragging) {
				var force: Vector3D = clickcurrent.add(clickoffset).subtract(chairRB.position);
				force.scaleBy(10);
				chairRB.applyCentralForce(force);
				chairRB.activate();
			}
		}
		
		private function updateChairLocation(): void {
			if (dragging) {
				var loc: Vector3D = clickcurrent.add(clickoffset);
				chairRB.position = loc;
			}
		}
		
		private function handleEnterFrame(e : Event) : void {
//			if (chairRB) { trace("chairLoc: " + chairRB.position); }
			updateChairForce();
//			updateChairLocation();
			physicsWorld.stepSimulation(timeStep);
			_view.render();
		}
	}
}