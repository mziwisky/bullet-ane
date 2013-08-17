//
//  aneInitializers.m
//  BulletANE
//
//  Created by Michael Ziwisky on 7/1/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#import "FlashRuntimeExtensions.h"

#define DECLARE_FREFUNC(name) FREObject name (FREContext, void*, uint32_t, FREObject[])

#define ADD_FREFUNC(num, handle, ptr) \
    func[num].name = (const uint8_t*) handle; \
    func[num].functionData = NULL; \
    func[num].function = &ptr

// === DiscreteDynamicsWorld ===
DECLARE_FREFUNC(createDiscreteDynamicsWorldWithDbvt);
DECLARE_FREFUNC(disposeDynamicsWorld);
DECLARE_FREFUNC(DiscreteDynamicsWorldaddCollisionObject);
DECLARE_FREFUNC(DiscreteDynamicsWorldremoveCollisionObject);
DECLARE_FREFUNC(DiscreteDynamicsWorldaddRigidBody);
DECLARE_FREFUNC(DiscreteDynamicsWorldremoveRigidBody);
DECLARE_FREFUNC(DiscreteDynamicsWorldstepSimulation);
DECLARE_FREFUNC(DiscreteDynamicsWorldaddConstraint);
DECLARE_FREFUNC(DiscreteDynamicsWorldremoveConstraint);
DECLARE_FREFUNC(DiscreteDynamicsWorldsetGravity);

// === StaticPlaneShape ===
DECLARE_FREFUNC(createStaticPlaneShape);

// === BoxShape ===
DECLARE_FREFUNC(createBoxShape);

// === SphereShape ===
DECLARE_FREFUNC(createSphereShape);

// === CylinderShape ===
DECLARE_FREFUNC(createCylinderShape);

// === ConeShape ===
DECLARE_FREFUNC(createConeShape);

// === CapsuleShape ===
DECLARE_FREFUNC(createCapsuleShape);

// === CompoundShape ===
DECLARE_FREFUNC(createCompoundShape);
DECLARE_FREFUNC(CompoundShapeaddChildShape);
DECLARE_FREFUNC(CompoundShaperemoveChildShape);

// === CollisionObject ===
DECLARE_FREFUNC(createCollisionObject);
DECLARE_FREFUNC(CollisionObjectgetWorldTransform);
DECLARE_FREFUNC(CollisionObjectsetWorldTransform);
DECLARE_FREFUNC(CollisionObjectgetCollisionFlags);
DECLARE_FREFUNC(CollisionObjectsetCollisionFlags);
DECLARE_FREFUNC(CollisionObjectactivate);

// === RigidBody ===
DECLARE_FREFUNC(createRigidBody);
DECLARE_FREFUNC(RigidBodyapplyCentralImpulse);
DECLARE_FREFUNC(RigidBodysetLinearFactor);
DECLARE_FREFUNC(RigidBodysetAngularFactor);
DECLARE_FREFUNC(RigidBodygetLinearVelocity);
DECLARE_FREFUNC(RigidBodysetLinearVelocity);
DECLARE_FREFUNC(RigidBodysetMass);
DECLARE_FREFUNC(RigidBodyapplyCentralForce);
DECLARE_FREFUNC(RigidBodyapplyTorque);
DECLARE_FREFUNC(RigidBodysetAngularVelocity);
DECLARE_FREFUNC(RigidBodygetAngularVelocity);
DECLARE_FREFUNC(RigidBodyapplyTorqueImpulse);
DECLARE_FREFUNC(RigidBodyaddConstraintRef);
DECLARE_FREFUNC(RigidBodyremoveConstraintRef);
DECLARE_FREFUNC(RigidBodygetConstraintRef);
DECLARE_FREFUNC(RigidBodygetNumConstraintRefs);

// === Generic6DofConstraint
DECLARE_FREFUNC(createGeneric6DofConstraint);
DECLARE_FREFUNC(Generic6DofConstraintsetLinearLimits);
DECLARE_FREFUNC(Generic6DofConstraintsetAngularLimits);


// This initializes a CONTEXT of the ANE.  It is called by the runtime when the AS3 side
// calls ExtensionContext.createExtensionContext().
void BulletExtContextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet)
{
    FRENamedFunction *func;
    
    *numFunctionsToSet = 44;
    
    func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToSet);
    
    ADD_FREFUNC(0, "createDiscreteDynamicsWorldWithDbvt", createDiscreteDynamicsWorldWithDbvt);
    ADD_FREFUNC(1, "disposeDynamicsWorld", disposeDynamicsWorld);
    ADD_FREFUNC(2, "DiscreteDynamicsWorld::addCollisionObject", DiscreteDynamicsWorldaddCollisionObject);
    ADD_FREFUNC(3, "DiscreteDynamicsWorld::removeCollisionObject", DiscreteDynamicsWorldremoveCollisionObject);
    ADD_FREFUNC(4, "DiscreteDynamicsWorld::addRigidBody", DiscreteDynamicsWorldaddRigidBody);
    ADD_FREFUNC(5, "DiscreteDynamicsWorld::removeRigidBody", DiscreteDynamicsWorldremoveRigidBody);
    ADD_FREFUNC(6, "DiscreteDynamicsWorld::stepSimulation", DiscreteDynamicsWorldstepSimulation);
    ADD_FREFUNC(7, "createStaticPlaneShape", createStaticPlaneShape);
    ADD_FREFUNC(8, "createBoxShape", createBoxShape);
    ADD_FREFUNC(9, "createSphereShape", createSphereShape);
    ADD_FREFUNC(10, "createCollisionObject", createCollisionObject);
    ADD_FREFUNC(11, "createRigidBody", createRigidBody);
    ADD_FREFUNC(12, "CollisionObject::getWorldTransform", CollisionObjectgetWorldTransform);
    ADD_FREFUNC(13, "CollisionObject::setWorldTransform", CollisionObjectsetWorldTransform);
    ADD_FREFUNC(14, "createCylinderShape", createCylinderShape);
    ADD_FREFUNC(15, "createConeShape", createConeShape);
    ADD_FREFUNC(16, "createCapsuleShape", createCapsuleShape);
    ADD_FREFUNC(17, "createCompoundShape", createCompoundShape);
    ADD_FREFUNC(18, "CompoundShape::addChildShape", CompoundShapeaddChildShape);
    ADD_FREFUNC(19, "CompoundShape::removeChildShape", CompoundShaperemoveChildShape);
    ADD_FREFUNC(20, "RigidBody::applyCentralImpulse", RigidBodyapplyCentralImpulse);
    ADD_FREFUNC(21, "RigidBody::setLinearFactor", RigidBodysetLinearFactor);
    ADD_FREFUNC(22, "RigidBody::setAngularFactor", RigidBodysetAngularFactor);
    ADD_FREFUNC(23, "RigidBody::getLinearVelocity", RigidBodygetLinearVelocity);
    ADD_FREFUNC(24, "RigidBody::setMass", RigidBodysetMass);
    ADD_FREFUNC(25, "CollisionObject::getCollisionFlags", CollisionObjectgetCollisionFlags);
    ADD_FREFUNC(26, "CollisionObject::setCollisionFlags", CollisionObjectsetCollisionFlags);
    ADD_FREFUNC(27, "RigidBody::applyCentralForce", RigidBodyapplyCentralForce);
    ADD_FREFUNC(28, "RigidBody::setLinearVelocity", RigidBodysetLinearVelocity);
    ADD_FREFUNC(29, "CollisionObject::activate", CollisionObjectactivate);
    ADD_FREFUNC(30, "RigidBody::applyTorque", RigidBodyapplyTorque);
    ADD_FREFUNC(31, "DiscreteDynamicsWorld::addConstraint", DiscreteDynamicsWorldaddConstraint);
    ADD_FREFUNC(32, "DiscreteDynamicsWorld::removeConstraint", DiscreteDynamicsWorldremoveConstraint);
    ADD_FREFUNC(33, "createGeneric6DofConstraint", createGeneric6DofConstraint);
    ADD_FREFUNC(34, "Generic6DofConstraint::setLinearLimits", Generic6DofConstraintsetLinearLimits);
    ADD_FREFUNC(35, "Generic6DofConstraint::setAngularLimits", Generic6DofConstraintsetAngularLimits);
    ADD_FREFUNC(36, "DiscreteDynamicsWorld::setGravity", DiscreteDynamicsWorldsetGravity);
    ADD_FREFUNC(37, "RigidBody::setAngularVelocity", RigidBodysetAngularVelocity);
    ADD_FREFUNC(38, "RigidBody::getAngularVelocity", RigidBodygetAngularVelocity);
    ADD_FREFUNC(39, "RigidBody::applyTorqueImpulse", RigidBodyapplyTorqueImpulse);
    ADD_FREFUNC(40, "RigidBody::addConstraintRef", RigidBodyaddConstraintRef);
    ADD_FREFUNC(41, "RigidBody::removeConstraintRef", RigidBodyremoveConstraintRef);
    ADD_FREFUNC(42, "RigidBody::getConstraintRef", RigidBodygetConstraintRef);
    ADD_FREFUNC(43, "RigidBody::getNumConstraintRefs", RigidBodygetNumConstraintRefs);
    
    *functionsToSet = func;
}

void BulletExtContextFinalizer(FREContext ctx)
{
    return;
}

// This initializes the ANE.  It's only called by the runtime, and only one time, when the ANE is loaded.
void BulletExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    NSLog(@"Initializing BulletPhysics extension...");
    *extDataToSet = NULL;
    *ctxInitializerToSet = &BulletExtContextInitializer;
    *ctxFinalizerToSet = &BulletExtContextFinalizer;
}
