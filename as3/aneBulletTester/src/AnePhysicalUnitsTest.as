package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import ane.bulletphysics.collision.shapes.BoxShape;
	import ane.bulletphysics.collision.shapes.SphereShape;
	import ane.bulletphysics.dynamics.DiscreteDynamicsWorld;
	import ane.bulletphysics.dynamics.RigidBody;
	
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;

	public class AnePhysicalUnitsTest extends Sprite
	{
		private var _view: View3D;
		private var _light : PointLight;
		private var lightPicker:StaticLightPicker;
		private var physicsWorld : DiscreteDynamicsWorld;
		private var velocityCube: RigidBody;
		private var impulseCube: RigidBody;
		private var forceCube: RigidBody;
		private var force: Vector3D;
		
		private var timeStep : Number = 1.0 / 1000;
		private var timeToRun: Number = 3.0;
		private var masses: Number = 50.0;
		private var scaling: Number = 0.01;
		private var meter: Number = 1.0 / scaling;
		
		public function AnePhysicalUnitsTest()
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
			_light.y = 12*meter;
			_light.z = -9*meter;
			_view.scene.addChild(_light);
			
			lightPicker = new StaticLightPicker([_light]);
			
			_view.camera.lens.near = 1*meter;
			_view.camera.lens.far = 100*meter;
			_view.camera.y = _light.y;
			_view.camera.z = _light.z;
			_view.camera.rotationX = 65;
			
			// init the physics world
			physicsWorld = new DiscreteDynamicsWorld("dbvt", scaling);
			physicsWorld.gravity = new Vector3D();
			
			// Create an 11-meter "measuring stick"
			var material : ColorMaterial = new ColorMaterial(0xFF0000);
			material.lightPicker = lightPicker;
			var mesh:Mesh = new Mesh(new CubeGeometry(11*meter, meter, meter), material);
			_view.scene.addChild(mesh);
			
			// Create three 1-meter cubes
			var boxShape: BoxShape = new BoxShape(meter, meter, meter);
			var geom: CubeGeometry = new CubeGeometry(meter, meter, meter);
			material = new ColorMaterial(0x00FF00);
			material.lightPicker = lightPicker;
			mesh = new Mesh(geom, material);
			var pos: Vector3D = new Vector3D(-5*meter, 0, -1*meter);
			velocityCube = new RigidBody(boxShape, mesh, masses);
			velocityCube.position = pos;
			pos.incrementBy(new Vector3D(0, 0, -1*meter));
			physicsWorld.addRigidBody(velocityCube);
			_view.scene.addChild(mesh);
			mesh = new Mesh(geom, material);
			impulseCube = new RigidBody(boxShape, mesh, masses);
			impulseCube.position = pos;
			pos.incrementBy(new Vector3D(0, 0, -1*meter));
			physicsWorld.addRigidBody(impulseCube);
			_view.scene.addChild(mesh);
			mesh = new Mesh(geom, material);
			forceCube = new RigidBody(boxShape, mesh, masses);
			forceCube.position = pos;
			pos.incrementBy(new Vector3D(0, 0, -1*meter));
			physicsWorld.addRigidBody(forceCube);
			_view.scene.addChild(mesh);
			
			// Want all three to end up at the end of the measuring stick at the same time
			velocityCube.linearVelocity = new Vector3D(10/timeToRun, 0, 0);
			velocityCube.activate();
			impulseCube.applyCentralImpulse(new Vector3D(10*masses/timeToRun, 0, 0));
			impulseCube.activate();
			// deltaX = 0.5*a*t^2
			// 10 = 0.5*(F/m)*t^2
			// F = 20 * masses / timeToRun^2
			var xForce: Number = 20 * masses / (timeToRun*timeToRun);
			force = new Vector3D(xForce, 0, 0);
//			forceCube.applyCentralForce(force);
			forceCube.activate();
		
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
		
		private function updateForces(): void {
			forceCube.applyCentralForce(force);
		}
		
		private function killVelocities(): void {
			const zero: Vector3D = new Vector3D();
			velocityCube.linearVelocity = zero;
			impulseCube.linearVelocity = zero;
			forceCube.linearVelocity = zero;
		}
		
		private var elapsed: Number = 0;
		private var once: Boolean = true;
		
		private function handleEnterFrame(e : Event) : void {
			if (elapsed < timeToRun) {
				updateForces();
				physicsWorld.stepSimulation(timeStep, 1, timeStep);
				elapsed += timeStep;
				trace("Elapsed time: " + elapsed);
			} else if (once) {
				once = !once;
				killVelocities();
				trace("Done! Total time: " + elapsed);
				trace("Final cube positions: " + velocityCube.position.x/meter + 
					", " + impulseCube.position.x/meter + 
					", and " + forceCube.position.x/meter);
			}
			
			_view.render();
		}
	}
}