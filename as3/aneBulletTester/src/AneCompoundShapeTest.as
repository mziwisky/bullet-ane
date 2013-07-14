package {
	import com.vizar3d.ane.bullet.collision.shapes.BoxShape;
	import com.vizar3d.ane.bullet.collision.shapes.CompoundShape;
	import com.vizar3d.ane.bullet.collision.shapes.SphereShape;
	import com.vizar3d.ane.bullet.collision.shapes.StaticPlaneShape;
	import com.vizar3d.ane.bullet.dynamics.DiscreteDynamicsWorld;
	import com.vizar3d.ane.bullet.dynamics.RigidBody;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.primitives.SphereGeometry;
	
	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")]
	public class AneCompoundShapeTest extends Sprite {
		private var _view : View3D;
		private var _light : PointLight;
		private var lightPicker:StaticLightPicker;
		private var physicsWorld : DiscreteDynamicsWorld;
		private var sphereShape : SphereShape;
		private var timeStep : Number = 1.0 / 60;
		
//		private var debugDraw:AWPDebugDraw;
		
		public function AneCompoundShapeTest() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_view = new View3D();
			this.addChild(_view);
			this.addChild(new AwayStats(_view));
			
			_light = new PointLight();
			_light.y = 3000;
			_light.z = -5000;
			_view.scene.addChild(_light);
			
			lightPicker = new StaticLightPicker([_light]);
			
			_view.camera.lens.far = 10000;
			_view.camera.y = _light.y;
			_view.camera.z = _light.z;
			_view.camera.rotationX = 25;
			
			// init the physics world
			physicsWorld = new DiscreteDynamicsWorld();
			
//			debugDraw = new AWPDebugDraw(_view, physicsWorld);
//			debugDraw.debugMode = AWPDebugDraw.DBG_NoDebug;
			
			// create ground mesh
			var material : ColorMaterial = new ColorMaterial(0x252525);
			material.lightPicker = lightPicker;
			var ground : Mesh = new Mesh(new PlaneGeometry(50000, 50000),material);
			ground.mouseEnabled = true;
			ground.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			_view.scene.addChild(ground);
			
			// create ground shape and rigidbody
			var groundShape : StaticPlaneShape = new StaticPlaneShape(new Vector3D(0, 1, 0), 0);
			var groundRigidbody : RigidBody = new RigidBody(groundShape, ground, 0);
			physicsWorld.addRigidBody(groundRigidbody);
			
			// create a wall
			var wall : Mesh = new Mesh(new CubeGeometry(20000, 5000, 100), material);
			_view.scene.addChild(wall);
			
			var wallShape : BoxShape = new BoxShape(20000, 5000, 100);
			var wallRigidbody : RigidBody = new RigidBody(wallShape, wall, 0);
			physicsWorld.addRigidBody(wallRigidbody);
			
			wallRigidbody.position = new Vector3D(0, 2500, 2000);
			
			// create sphere shape
			sphereShape = new SphereShape(100);
			
			// create chair shape
			var chairShape : CompoundShape = createChairShape();
			material = new ColorMaterial(0xe28313);
			material.lightPicker = lightPicker;
			
			// create chair rigidbodies
			var mesh : ObjectContainer3D;
			var body : RigidBody;
			for (var i : int; i < 10; i++ ) {
				mesh = createChairMesh(material);
				_view.scene.addChild(mesh);
				body = new RigidBody(chairShape, mesh, 1);
//				body.friction = .9;
				body.position = new Vector3D(0, 500 + 1000 * i, 0);
				physicsWorld.addRigidBody(body);
			}
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
			stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		private function onResize(e: Event): void {
			_view.stage3DProxy.width = stage.stageWidth;
			_view.width = stage.stageWidth;
			_view.stage3DProxy.height = stage.stageHeight;
			_view.height = stage.stageHeight;
		}
		
		private function createChairMesh(material : ColorMaterial) : ObjectContainer3D {
			var mesh : ObjectContainer3D = new ObjectContainer3D();
			
			var child1 : Mesh = new Mesh(new CubeGeometry(460, 60, 500),material);
			var child2 : Mesh = new Mesh(new CubeGeometry(60, 400, 60),material);
			var child3 : Mesh = new Mesh(new CubeGeometry(60, 400, 60),material);
			var child4 : Mesh = new Mesh(new CubeGeometry(60, 400, 60),material);
			var child5 : Mesh = new Mesh(new CubeGeometry(60, 400, 60),material);
			var child6 : Mesh = new Mesh(new CubeGeometry(400, 500, 60),material);
			child2.position = new Vector3D(-180, -220, -200);
			child3.position = new Vector3D(180, -220, -200);
			child4.position = new Vector3D(180, -220, 200);
			child5.position = new Vector3D(-180, -220, 200);
			child6.position = new Vector3D(0, 250, 250);
			child6.rotate(new Vector3D(1, 0, 0), 20);
			mesh.addChild(child1);
			mesh.addChild(child2);
			mesh.addChild(child3);
			mesh.addChild(child4);
			mesh.addChild(child5);
			mesh.addChild(child6);
			return mesh;
		}
		
		private function createChairShape() : CompoundShape {
			var boxShape1 : BoxShape = new BoxShape(460, 60, 500);
			var boxShape2 : BoxShape = new BoxShape(60, 400, 60);
			var boxShape3 : BoxShape = new BoxShape(400, 500, 60);
			var transform: Matrix3D = new Matrix3D();
			
			var chairShape : CompoundShape = new CompoundShape();
			chairShape.addChildShape(boxShape1, transform);
			transform.position = new Vector3D(-180, -220, -200);
			chairShape.addChildShape(boxShape2, transform);
			transform.position = new Vector3D(180, -220, -200);
			chairShape.addChildShape(boxShape2, transform);
			transform.position = new Vector3D(180, -220, 200);
			chairShape.addChildShape(boxShape2, transform);
			transform.position = new Vector3D(-180, -220, 200);
			chairShape.addChildShape(boxShape2, transform);
			
			transform.position = new Vector3D(0, 250, 250);
			transform.prependRotation(20, new Vector3D(1, 0, 0));
			chairShape.addChildShape(boxShape3, transform);
			
			return chairShape;
		}
		
		private function onMouseUp(event : MouseEvent3D) : void {
			var pos : Vector3D = _view.camera.position;
			var mpos : Vector3D = new Vector3D(event.localPosition.x, event.localPosition.y, event.localPosition.z);
			
			var impulse : Vector3D = mpos.subtract(pos);
			impulse.normalize();
			impulse.scaleBy(20000);
			
			// shoot a sphere
			var material : ColorMaterial = new ColorMaterial(0xfc6a11);
			material.lightPicker = lightPicker;
			
			var sphere : Mesh = new Mesh(new SphereGeometry(100),material);
			_view.scene.addChild(sphere);
			
			var body : RigidBody = new RigidBody(sphereShape, sphere, 2);
			body.position = pos;
			physicsWorld.addRigidBody(body);
			
			body.applyCentralImpulse(impulse);
		}
		
		private function handleEnterFrame(e : Event) : void {
			physicsWorld.stepSimulation(timeStep);
//			debugDraw.debugDrawWorld();
			_view.render();
		}
	}
}
import away3d.materials.lightpickers.StaticLightPicker;

