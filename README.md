Bullet.ane
======

An Adobe AIR Native Extension for the Bullet Physics Simulation Library

Imbue your AIR mobile and desktop apps with the magic of physics!

Compared with AwayPhysics, Bullet.ane increases performance on mobile apps by 
an order of magnitude.  See a video comparison: 
[http://youtu.be/IH4mrUagA74](http://youtu.be/IH4mrUagA74)


Currently written to work with Away3D, but certainly could be made compatible 
with other Stage3D-based AS3 graphics libraries.

True native implementations are built for iOS (7.0 SDK), iOS Simulator, and 
Android.  All other platforms (which I think is only desktops now that Android 
is supported, right?) fall back on 
[AwayPhysics](https://github.com/away3d/awayphysics-core-fp11), a pure-AS3 
implementation of Bullet, meaning the extension will work on all platforms AIR 
supports.

---

The rest of the README:

* Getting Started
* Building the ANE
* Comparison to AwayPhysics and Bullet C++ Lib
	* Bullet.ane vs. Bullet C++ Lib
	* Bullet.ane vs. AwayPhysics
	* Nested Meshes
	* A Word on Scaling
* To-do
* Links


Getting Started
-----

For convenience, the compiled extension is included in the repository, located 
at `as3/aneBulletTester/ane/Bullet.ane`.  Usage examples can be found in 
`as3/aneBulletTester/src/`.

If you're already familiar with using ANEs, then go wild.

But if this is your first ANE experience... To add it to your ActionScript 
Mobile project in Flash Builder 4.7 (sorry, I don't know about other IDEs), 
right-click your project and select `Properties`, then click `ActionScript 
Build Path` on the left side-bar, then `Native Extensions` across the top, 
then `Add ANE...`

Finally, ensure the extension gets packaged with your debug and release 
builds; from the `Properties` window, twist open `ActionScript Build 
Packaging` on the left and select `Apple iOS`, then click `Native Extensions` 
across the top and ensure that the `Package` checkbox is checked.  Do the same 
with the `Android` platform.


Building the ANE
-----

If you're the type that's going to build `Bullet.ane` from source, this 
section should help.  It might not be very complete, so I apologize -- ask on 
GitHub if you need help (github.com/mziwisky/bullet-ane).

First off, if you don't have a Mac, I can't help you (yet), because I'm 
building the native iOS library with Xcode.  Also, I rely on Flash Builder for 
the ActionScript compilation, so I can't help with other IDEs.

OK, you'll need to acquire the following AS3 dependencies:

* [Away3D](https://github.com/away3d/away3d-core-fp11)
* [AwayPhysics](https://github.com/away3d/awayphysics-core-fp11)

`as3/aneBulletLib` depends on Away3D and `as3/aneBulletDefault` depends on 
both.  Build those two `aneBullet*` projects.

Then, `cd` to `native/bullet-itself` and run 
`./fetchSourceAndMakeXcodeProjects.bash`.

Then, open `native/ios/BulletANE/BulletANE.xcodeproj` in Xcode and build it 
for both iOS Device and iPad Simulator.

Then, `cd` back to the top directory and edit the properties in `build.xml` to 
accomodate your system.  Most of it should be alright, but you may need to 
change `airsdk.dir` and `iossdk.dir`.

Finally, run `ant` in the top directory.

Again, if anything goes wrong here that you can't figure out on your own, feel 
free to contact me on GitHub.


Comparison to AwayPhysics and Bullet C++ Lib
-----

Bullet.ane is certainly inspired by AwayPhysics, but where AwayPhysics methods 
differ from their Bullet Lib counterpart, Bullet.ane tends to favor the Bullet 
C++ Lib version over the AwayPhysics version.  This choice was made so that 
the Bullet Lib documentation, forum posts, etc. are more likely to be accurate 
and helpful in using Bullet.ane.

For example, the AwayPhysics method `AWPRigidBody::applyForce()` implicitly 
calls `AWPRigidBody::activate()` after applying the force.  Bullet Lib's 
`btRigidBody::applyForce()` does not implicitly call 
`btRigidBody::activate()`, and nor does Bullet.ane's `RigidBody::applyForce()` 
call `RigidBody::activate()`.

There are, however, a few things I preferred about AwayPhysics' API, so I made 
some deviations from Bullet Lib in a few spots.

For example, the `Generic6DofConstraint` constructor takes a position vector 
and rotation vector argument for each of the two involved bodies' frames, 
rather than a transform matrix for each of the frames.

I won't make a comprehensive list here of the differences between Bullet.ane 
and AwayPhysics, but I'll try to note all the differences between the 
semantics of Bullet.ane and Bullet Lib which might lead to headaches if you 
don't realize them.  I'll also point out a few ways in which Bullet.ane tends 
to differ from AwayPhysics.

#### Bullet.ane vs. Bullet C++ Lib ####

* The Bullet.ane `DiscreteDynamicsWorld` constructor will create a world with 
  the same default configuration that AwayPhysics uses in its 
`::initWithDbvtBroadphase()` method.  So you don't have to do all the typical 
boilerplate code that Bullet Lib requires.  On the other hand, you don't have 
control over the things that the boilerplate code constructs, like the 
CollisionConfiguration and CollisionDispatcher.
* The Bullet.ane `DiscreteDynamicsWorld::addRigidBody()` method, when called 
  without the optional `group` and `mask` parameters, defaults to `group=1` 
and `mask=-1`.  This is indeed what Bullet Lib does for dynamic (i.e., 
non-static && non-kinematic) RigidBodies, but not for non-dynamic bodies.  
Bullet.ane does so regardless of the dynamic-ness.
* The Bullet.ane `BoxShape` takes full-extents as parameters.  The Bullet Lib 
  counterpart takes half-extents.

#### Bullet.ane vs. AwayPhysics ####

* Bullet.ane performs initialization of a `DiscreteDynamicsWorld` within the 
  constructor as opposed to AwayPhysics, which requires a call to 
`AWPDynamicsWorld::initWithDbvtBroadphase()` after construction.
* AwayPhysics expects any arguments that are rotation vectors to be Euler 
  angles in degrees.  Bullet.ane expects them to be Euler angles in radians.
* Bullet.ane often expects a `Matrix3D` defining a transform as a method 
  parameter where AwayPhysics would expect a pair of `Vector3D`s defining a 
position and a rotation.  E.g., in `CompoundShape::addChildShape()`.

#### Nested Meshes ####

Here's what happened.  I was building this app which had an ObjectContainer3D 
hierarchy.  (NOTE: I'm going to talk about some Away3D classes here, like 
ObjectContainer3D.  And Mesh.)  Each visible Mesh was a child of one of a set 
of invisible ObjectContainer3Ds, and each of those ObjectContainer3Ds was a 
child of the Scene3D.  The ObjectContainer3Ds each had a non-identity 
transform, as did each of the visible Meshes.

I wanted the Meshes to act like physical objects, so I associated each one 
with a RigidBody, but I did *not* want the ObjectContainer3Ds to be involved 
in the physics.  An Away3D Mesh can have its *local* transform matrix 
manipulated directly, but not its *scene* transform.  So when I let Bullet 
take control over the Meshes transforms, it treated them all as direct 
children of a single scene, not realizing that their visual representation was 
actually modulated by the transform of their parent ObjectContainer3Ds.  This 
caused problems such as objects colliding when they were visually very far 
apart, e.g., if they each have a local transform of identity, but their 
parents have transforms that are far from each other.

To reconcile this, the `DiscreteDynamicsWorld` constructor takes a boolean 
parameter, `expectNestedMeshes`, which defaults to `false`.  If it's set to 
`true`, then the scenario I described above is fixed; the ANE uses the inverse 
scene transform of each Mesh's parent to figure out how to set the Mesh's 
local transform such that its scene transform correctly matches its Bullet 
world transform.

Most people won't need to deal with this, because the typical use case will be 
to add Bullet-controlled Meshes directly to the Scene3D, not to parent 
containers.

#### A Word on Scaling ####

By default, the Bullet C++ Lib assumes all units to be SI -- sizes and 
positions are meters, masses are kilograms, time is seconds, etc.  Bullet Lib 
works best when moving objects are in the size range of 0.05 to 10.0 units 
(meters).  Refer to [the Bullet wiki page on scaling the 
world](http://www.bulletphysics.org/mediawiki-1.5.8/index.php?title=Scaling_The_World).

As a convenience, the DiscreteDynamicsWorld constructor takes a `scaling` 
parameter, and the ANE multiplies all user-specified positions and sizes by 
`(1/scaling)` before it passes those values to the Bullet library.

Therefore, 1 Bullet unit equals `scaling` visual (Away3D) units.

The default `scaling` is 100.  So by default, the ANE will work best when 
moving objects are created with a size in the range of 5 to 1000.

Note that ONLY sizes and positions get scaled.  In spite of what the referred 
wiki page suggests, we don't scale velocities, torques, etc.  So a scaling of 
100 can be interpreted as follows.  All positions and sizes (both input to and 
output from the ANE) are in centimeters, but all other units remain SI.  
Therefore velocities are m/s (not cm/s), accelerations -- in particular 
acceleration due to gravity -- are m/s^2, forces are Newtons, torques are 
Newton-meters, etc. Note that this agrees with the convention that AwayPhysics 
uses (i.e., only scaling distances and sizes).


To-do
-----

An abbreviated list of things on the to-do list for the ANE.  Feel free to 
contribute!

* Native Desktop lib.  Right now it falls back on AwayPhysics, which is 
  awesome, but performs significantly worse than native code.
* Add support for other Stage3D-based graphics libraries.
* Maybe make a big start-to-finish build script if enough people are 
  interested in such a thing.
* Add collision callbacks.
* More and more API exposure.


Links
-----

#### Bullet Physics Library ####
* [Wiki](http://www.bulletphysics.org/mediawiki-1.5.8/index.php/Main_Page)
* [Forums](http://www.bulletphysics.org/Bullet/phpBB3)
* [Documentation](http://www.bulletphysics.org/mediawiki-1.5.8/index.php?title=Documentation)
* [Homepage](http://www.bulletphysics.org/)

#### AIR Native Extensions ####
* [Nice Adobe 
  reference](http://help.adobe.com/en_US/air/extensions/air_extensions.pdf)

