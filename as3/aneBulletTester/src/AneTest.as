package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import ane.bulletphysics.collision.shapes.BoxShape;
	import ane.bulletphysics.collision.shapes.ConeShape;
	import ane.bulletphysics.collision.shapes.CylinderShape;
	import ane.bulletphysics.collision.shapes.SphereShape;
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
	import away3d.primitives.SphereGeometry;
	
	public class AneTest extends Sprite
	{
		private var _view: View3D;
		private var _light : PointLight;
		private var lightPicker:StaticLightPicker;
		private var _physicsWorld : DiscreteDynamicsWorld;
		private var _sphereShape : SphereShape;
		private var _timeStep : Number = 1.0 / 60;
		private var scale: Number = .1;
		
		public function AneTest()
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_view = new View3D();
			this.addChild(_view);
			this.addChild(new AwayStats(_view));
			
			_light = new PointLight();
			_light.y = 2500*scale;
			_light.z = -4000*scale;
			_view.scene.addChild(_light);
			
			lightPicker = new StaticLightPicker([_light]);
			
			_view.camera.lens.near = 100*scale;
			_view.camera.lens.far = 10000*scale;
			_view.camera.y = _light.y;
			_view.camera.z = _light.z;
			_view.camera.rotationX = 25;
			
			// init the physics world
			_physicsWorld = new DiscreteDynamicsWorld();
			
//			debugDraw = new AWPDebugDraw(_view, _physicsWorld);
//			debugDraw.debugMode |= AWPDebugDraw.DBG_DrawTransform;
			
			// create ground mesh
			var material : ColorMaterial = new ColorMaterial(0x252525);
			material.lightPicker = lightPicker;
			var mesh:Mesh=new Mesh(new PlaneGeometry(50000*scale, 50000*scale),material);
			mesh.mouseEnabled = true;
			mesh.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			_view.scene.addChild(mesh);
			
			// create ground shape and rigidbody
			var groundShape : StaticPlaneShape = new StaticPlaneShape(new Vector3D(0, 1, 0), 0);
			var groundRigidbody : RigidBody = new RigidBody(groundShape, mesh, 0);
			_physicsWorld.addRigidBody(groundRigidbody);
			
			// create a wall
			mesh = new Mesh(new CubeGeometry(20000*scale, 2000*scale, 100*scale),material);
			_view.scene.addChild(mesh);
			
			var wallShape : BoxShape = new BoxShape(20000*scale, 2000*scale, 100*scale);
			var wallRigidbody : RigidBody = new RigidBody(wallShape, mesh, 0);
			_physicsWorld.addRigidBody(wallRigidbody);
			
			wallRigidbody.position = new Vector3D(0, 1000*scale, 2000*scale);
			
			material = new ColorMaterial(0xfc6a11);
			material.lightPicker = lightPicker;
			
			// create rigidbody shapes
			_sphereShape = new SphereShape(100*scale);
			var boxShape : BoxShape = new BoxShape(200*scale, 200*scale, 200*scale);
			var cylinderShape : CylinderShape = new CylinderShape(100*scale, 200*scale);
			var coneShape : ConeShape = new ConeShape(100*scale, 200*scale); trace("cone height: " + 200*scale);
			
			// create rigidbodies
			var body : RigidBody;
			var numx : int = 1;
			var numy : int = 8;
			var numz : int = 1;
			for (var i : int = 0; i < numx; i++ ) {
				for (var j : int = 0; j < numz; j++ ) {
					for (var k : int = 0; k < numy; k++ ) {
						// create boxes
						mesh = new Mesh(new CubeGeometry(200*scale, 200*scale, 200*scale),material);
						_view.scene.addChild(mesh);
						body = new RigidBody(boxShape, mesh, 1);
						body.friction = .9;
						body.ccdSweptSphereRadius = 0.5*scale;
						body.ccdMotionThreshold = 1*scale;
						body.position = new Vector3D(-1000*scale + i * 200*scale, 100*scale + k * 200*scale+1300*scale, j * 200*scale);
						_physicsWorld.addRigidBody(body);
						
						// create cylinders
						mesh = new Mesh(new CylinderGeometry(100*scale, 100*scale, 200*scale),material);
						_view.scene.addChild(mesh);
						body = new RigidBody(cylinderShape, mesh, 1);
						body.friction = .9;
						body.ccdSweptSphereRadius = 0.5*scale;
						body.ccdMotionThreshold = 1*scale;
						body.position = new Vector3D(1000*scale + i * 200*scale, 100*scale + k * 200*scale, j * 200*scale);
						_physicsWorld.addRigidBody(body);
						
						// create the Cones
						mesh = new Mesh(new ConeGeometry(100*scale, 200*scale),material);
						_view.scene.addChild(mesh);
						body = new RigidBody(coneShape, mesh, 1);
						body.friction = .9;
						body.ccdSweptSphereRadius = 0.5*scale;
						body.ccdMotionThreshold = 1*scale;
						body.position = new Vector3D(i * 200*scale, 100*scale + k * 230*scale, j * 200*scale);
						trace (body.position.y);
						_physicsWorld.addRigidBody(body);
					}
				}
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
		
		private function onMouseUp(event : MouseEvent3D) : void {
			var pos : Vector3D = _view.camera.position;
			var mpos : Vector3D = new Vector3D(event.localPosition.x, event.localPosition.y, event.localPosition.z);
			
			var impulse : Vector3D = mpos.subtract(pos);
			impulse.normalize();
			impulse.scaleBy(2000*scale);
			
			// shoot a sphere
			var material : ColorMaterial = new ColorMaterial(0xb35b11);
			material.lightPicker = lightPicker;
			
			var sphere : Mesh = new Mesh(new SphereGeometry(100*scale),material);
			_view.scene.addChild(sphere);
			
			var body : RigidBody = new RigidBody(_sphereShape, sphere, 2);
			body.position = pos;
			body.ccdSweptSphereRadius = 0.5*scale;
			body.ccdMotionThreshold = 1*scale;
			_physicsWorld.addRigidBody(body);
			
			body.applyCentralImpulse(impulse);
		}
		
		private var ticks: uint;
		
		private function handleEnterFrame(e : Event) : void {
			const newTick: uint = getTimer();
			const step: Number = Number(newTick - ticks) / 1000.0;
			_physicsWorld.stepSimulation(step, 6, _timeStep/2);
//			_physicsWorld.stepSimulation(_timeStep, 2, _timeStep/2);
			ticks = newTick;
			
			//debugDraw.debugDrawWorld();
			_view.render();
		}
	}
}