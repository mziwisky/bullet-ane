package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import ane.bulletphysics.collision.shapes.BoxShape;
	import ane.bulletphysics.collision.shapes.ConeShape;
	import ane.bulletphysics.collision.shapes.CylinderShape;
	import ane.bulletphysics.collision.shapes.StaticPlaneShape;
	import ane.bulletphysics.dynamics.DiscreteDynamicsWorld;
	import ane.bulletphysics.dynamics.RigidBody;
	
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.ConeGeometry;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.CylinderGeometry;
	import away3d.primitives.PlaneGeometry;
	
	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")]
	public class AneGravityTest extends Sprite {
		private var _view : View3D;
		private var _light : PointLight;
		private var lightPicker:StaticLightPicker;
		private var physicsWorld : DiscreteDynamicsWorld;
		private var timeStep : Number = 1.0 / 60;
		private var isMouseDown : Boolean;
		private var currMousePos : Vector3D;
		
		private var nonStaticRigidBodies: Vector.<RigidBody> = new Vector.<RigidBody>();
		
//		private var debugDraw:AWPDebugDraw;
		
		public function AneGravityTest() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_view = new View3D();
			this.addChild(_view);
			this.addChild(new AwayStats(_view));
			
			_light = new PointLight();
			_light.y = 0;
			_light.z = -3000;
			_view.scene.addChild(_light);
			
			lightPicker = new StaticLightPicker([_light]);
			
			_view.camera.lens.far = 10000;
			_view.camera.y = _light.y;
			_view.camera.z = _light.z;
			
			// init the physics world
			physicsWorld = new DiscreteDynamicsWorld();
			physicsWorld.gravity = new Vector3D(0, 0, 20);
			
//			debugDraw = new AWPDebugDraw(_view, physicsWorld);
//			debugDraw.debugMode = AWPDebugDraw.DBG_NoDebug;
			
			// create ground mesh
			var material : ColorMaterial = new ColorMaterial(0x252525);
			material.lightPicker = lightPicker;
			var ground :Mesh = new Mesh(new PlaneGeometry(50000, 50000), material);
			ground.mouseEnabled = true;
			ground.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			ground.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			ground.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove);
			_view.scene.addChild(ground);
			
			// create ground shape and rigidbody
//			var groundShape : StaticPlaneShape = new StaticPlaneShape(new Vector3D(0, 1, 0), 0);
			var groundShape : StaticPlaneShape = new StaticPlaneShape(new Vector3D(0, 0, -1), 0);
			var groundRigidbody : RigidBody = new RigidBody(groundShape, ground, 0);
			physicsWorld.addRigidBody(groundRigidbody);
			
//			groundRigidbody.rotation = new Vector3D( -90, 0, 0);
			ground.rotationX = -90;
			
			material = new ColorMaterial(0xe28313);
			material.lightPicker = lightPicker;
			
			// create rigidbody shapes
			var boxShape : BoxShape = new BoxShape(100, 100, 100);
			var cylinderShape : CylinderShape = new CylinderShape(50, 100);
			var coneShape : ConeShape = new ConeShape(50, 100);
			
			// create rigidbodies
			var mesh : Mesh;
			var body : RigidBody;
			for (var i : int; i < 20; i++ ) {
				// create boxes
				mesh = new Mesh(new CubeGeometry(100, 100, 100), material);
				_view.scene.addChild(mesh);
				body = new RigidBody(boxShape, mesh, 1);
				body.friction = .9;
				body.linearDamping = .5;
				body.position = new Vector3D(-1000 + 2000 * Math.random(), -1000 + 2000 * Math.random(), -1000 - 2000 * Math.random());
				physicsWorld.addRigidBody(body);
				nonStaticRigidBodies.push(body);
				
				// create cylinders
				mesh = new Mesh(new CylinderGeometry(50, 50, 100) ,material);
				_view.scene.addChild(mesh);
				body = new RigidBody(cylinderShape, mesh, 1);
				body.friction = .9;
				body.linearDamping = .5;
				body.position = new Vector3D(-1000 + 2000 * Math.random(), -1000 + 2000 * Math.random(), -1000 - 2000 * Math.random());
				physicsWorld.addRigidBody(body);
				nonStaticRigidBodies.push(body);
				
				// create the Cones
				mesh = new Mesh(new ConeGeometry(50, 100),material);
				_view.scene.addChild(mesh);
				body = new RigidBody(coneShape, mesh, 1);
				body.friction = .9;
				body.linearDamping = .5;
				body.position = new Vector3D(-1000 + 2000 * Math.random(), -1000 + 2000 * Math.random(), -1000 - 2000 * Math.random());
				physicsWorld.addRigidBody(body);
				nonStaticRigidBodies.push(body);
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
		
		private function onMouseDown(event : MouseEvent3D) : void {
			isMouseDown = true;
			currMousePos = new Vector3D(event.localPosition.x, event.localPosition.z, -600);
			this.addEventListener(Event.ENTER_FRAME, handleGravity);
		}
		
		private function onMouseUp(event : MouseEvent3D) : void {
			isMouseDown = false;
			
			var pos : Vector3D = new Vector3D();
			for each (var body:RigidBody in nonStaticRigidBodies) {
				pos = pos.add(body.position);
			}
			pos.scaleBy(1 / nonStaticRigidBodies.length);
			
			var impulse : Vector3D;
			for each (body in nonStaticRigidBodies) {
				impulse = body.position.subtract(pos);
				impulse.scaleBy(5000 / impulse.lengthSquared);
				body.applyCentralImpulse(impulse);
			}
			
			physicsWorld.gravity = new Vector3D(0, 0, 20);
			this.removeEventListener(Event.ENTER_FRAME, handleGravity);
		}
		
		private function onMouseMove(event : MouseEvent3D) : void {
			if (isMouseDown) {
				currMousePos = new Vector3D(event.localPosition.x, event.localPosition.z, -600);
			}
		}
		
		private function handleGravity(e : Event) : void {
			var gravity : Vector3D;
			for each (var body:RigidBody in nonStaticRigidBodies) {
				gravity = currMousePos.subtract(body.position);
				gravity.normalize();
				gravity.scaleBy(100);
				
				body.gravity = gravity;
			}
		}
		
		private function handleEnterFrame(e : Event) : void {
			physicsWorld.stepSimulation(timeStep);
//			debugDraw.debugDrawWorld();
			_view.render();
		}
	}
}
