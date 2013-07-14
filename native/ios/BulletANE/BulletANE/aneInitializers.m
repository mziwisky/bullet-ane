//
//  aneInitializers.m
//  BulletANE
//
//  Created by Michael Ziwisky on 7/1/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#define DECLARE_FREFUNC(name) FREObject name (FREContext, void*, uint32_t, FREObject[])

// === DiscreteDynamicsWorld ===
DECLARE_FREFUNC(createDiscreteDynamicsWorldWithDbvt);
DECLARE_FREFUNC(disposeDynamicsWorld);
DECLARE_FREFUNC(DiscreteDynamicsWorldaddCollisionObject);
DECLARE_FREFUNC(DiscreteDynamicsWorldremoveCollisionObject);
DECLARE_FREFUNC(DiscreteDynamicsWorldaddRigidBody);
DECLARE_FREFUNC(DiscreteDynamicsWorldremoveRigidBody);
DECLARE_FREFUNC(DiscreteDynamicsWorldstepSimulation);

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

// === RigicBody ===
DECLARE_FREFUNC(createRigidBody);
DECLARE_FREFUNC(RigidBodyapplyCentralImpulse);
DECLARE_FREFUNC(RigidBodysetLinearFactor);
DECLARE_FREFUNC(RigidBodysetAngularFactor);
DECLARE_FREFUNC(RigidBodygetLinearVelocity);


// This initializes a CONTEXT of the ANE.  It is called by the runtime when the AS3 side
// calls ExtensionContext.createExtensionContext().
void BulletExtContextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet, const FRENamedFunction **functionsToSet)
{
    FRENamedFunction *func;
    
    *numFunctionsToSet = 24;
    
    func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToSet);
    
    func[0].name = (const uint8_t*) "createDiscreteDynamicsWorldWithDbvt";
    func[0].functionData = NULL;
    func[0].function = &createDiscreteDynamicsWorldWithDbvt;
    
    func[1].name = (const uint8_t*) "disposeDynamicsWorld";
    func[1].functionData = NULL;
    func[1].function = &disposeDynamicsWorld;
    
    func[2].name = (const uint8_t*) "DiscreteDynamicsWorld::addCollisionObject";
    func[2].functionData = NULL;
    func[2].function = &DiscreteDynamicsWorldaddCollisionObject;
    
    func[3].name = (const uint8_t*) "DiscreteDynamicsWorld::removeCollisionObject";
    func[3].functionData = NULL;
    func[3].function = &DiscreteDynamicsWorldremoveCollisionObject;
    
    func[4].name = (const uint8_t*) "DiscreteDynamicsWorld::addRigidBody";
    func[4].functionData = NULL;
    func[4].function = &DiscreteDynamicsWorldaddRigidBody;
    
    func[5].name = (const uint8_t*) "DiscreteDynamicsWorld::removeRigidBody";
    func[5].functionData = NULL;
    func[5].function = &DiscreteDynamicsWorldremoveRigidBody;
    
    func[6].name = (const uint8_t*) "DiscreteDynamicsWorld::stepSimulation";
    func[6].functionData = NULL;
    func[6].function = &DiscreteDynamicsWorldstepSimulation;
    
    func[7].name = (const uint8_t*) "createStaticPlaneShape";
    func[7].functionData = NULL;
    func[7].function = &createStaticPlaneShape;
    
    func[8].name = (const uint8_t*) "createBoxShape";
    func[8].functionData = NULL;
    func[8].function = &createBoxShape;
    
    func[9].name = (const uint8_t*) "createSphereShape";
    func[9].functionData = NULL;
    func[9].function = &createSphereShape;
    
    func[10].name = (const uint8_t*) "createCollisionObject";
    func[10].functionData = NULL;
    func[10].function = &createCollisionObject;
    
    func[11].name = (const uint8_t*) "createRigidBody";
    func[11].functionData = NULL;
    func[11].function = &createRigidBody;
    
    func[12].name = (const uint8_t*) "CollisionObject::getWorldTransform";
    func[12].functionData = NULL;
    func[12].function = &CollisionObjectgetWorldTransform;
    
    func[13].name = (const uint8_t*) "CollisionObject::setWorldTransform";
    func[13].functionData = NULL;
    func[13].function = &CollisionObjectsetWorldTransform;
    
    func[14].name = (const uint8_t*) "createCylinderShape";
    func[14].functionData = NULL;
    func[14].function = &createCylinderShape;
    
    func[15].name = (const uint8_t*) "createConeShape";
    func[15].functionData = NULL;
    func[15].function = &createConeShape;
    
    func[16].name = (const uint8_t*) "createCapsuleShape";
    func[16].functionData = NULL;
    func[16].function = &createCapsuleShape;
    
    func[17].name = (const uint8_t*) "createCompoundShape";
    func[17].functionData = NULL;
    func[17].function = &createCompoundShape;
    
    func[18].name = (const uint8_t*) "CompoundShape::addChildShape";
    func[18].functionData = NULL;
    func[18].function = &CompoundShapeaddChildShape;
    
    func[19].name = (const uint8_t*) "CompoundShape::removeChildShape";
    func[19].functionData = NULL;
    func[19].function = &CompoundShaperemoveChildShape;
    
    func[20].name = (const uint8_t*) "RigidBody::applyCentralImpulse";
    func[20].functionData = NULL;
    func[20].function = &RigidBodyapplyCentralImpulse;
    
    func[21].name = (const uint8_t*) "RigidBody::setLinearFactor";
    func[21].functionData = NULL;
    func[21].function = &RigidBodysetLinearFactor;
    
    func[22].name = (const uint8_t*) "RigidBody::setAngularFactor";
    func[22].functionData = NULL;
    func[22].function = &RigidBodysetAngularFactor;
    
    func[23].name = (const uint8_t*) "RigidBody::getLinearVelocity";
    func[23].functionData = NULL;
    func[23].function = &RigidBodygetLinearVelocity;
    
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
