//
//  DiscreteDynamicsWorldAPI.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 7/1/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"
#include "BulletCollision/CollisionDispatch/btGhostObject.h"

// Create DynamicsWorld
extern "C" FREObject createDiscreteDynamicsWorldWithDbvt(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    btDefaultCollisionConfiguration* collisionConfiguration = new btDefaultCollisionConfiguration();
    btCollisionDispatcher* dispatcher = new btCollisionDispatcher(collisionConfiguration);
    btBroadphaseInterface* overlappingPairCache = new btDbvtBroadphase();
    overlappingPairCache->getOverlappingPairCache()->setInternalGhostPairCallback(new btGhostPairCallback());
    btSequentialImpulseConstraintSolver* solver = new btSequentialImpulseConstraintSolver();
    
    btDiscreteDynamicsWorld* dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher, overlappingPairCache, solver, collisionConfiguration);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)dynamicsWorld, &ptr);
    return ptr;
}

extern "C" FREObject disposeDynamicsWorld(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    btDiscreteDynamicsWorld* dynamicsWorld;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    
    delete dynamicsWorld;
    return NULL;
}

// Create CollisionShapes
// DONE: box, sphere,
// TODO: cone, cylinder, capsule, convexHull, compound


// TODO: Modify CollisionShape properties

// TODO: Dispose CollisionShape

extern "C" FREObject DiscreteDynamicsWorldaddCollisionObject(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_object = argv[1];
    FREObject as3_group = argv[2];
    FREObject as3_mask = argv[3];
    btDiscreteDynamicsWorld* dynamicsWorld;
    uint32_t objPtr, group, mask;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsUint32(as3_object, &objPtr);
    FREGetObjectAsUint32(as3_group, &group);
    FREGetObjectAsUint32(as3_mask, &mask);
    
    dynamicsWorld->addCollisionObject((btCollisionObject*)objPtr, group, mask);
    return NULL;
}

extern "C" FREObject DiscreteDynamicsWorldremoveCollisionObject(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_object = argv[1];
    btDiscreteDynamicsWorld* dynamicsWorld;
    uint32_t objPtr;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsUint32(as3_object, &objPtr);
    
    dynamicsWorld->removeCollisionObject((btCollisionObject*)objPtr);
    return NULL;
}


extern "C" FREObject DiscreteDynamicsWorldaddRigidBody(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_body = argv[1];
    btDiscreteDynamicsWorld* dynamicsWorld;
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    
    dynamicsWorld->addRigidBody(body);
    return NULL;
}

extern "C" FREObject DiscreteDynamicsWorldremoveRigidBody(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_body = argv[1];
    btDiscreteDynamicsWorld* dynamicsWorld;
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    
    dynamicsWorld->removeRigidBody(body);
    return NULL;
}

// TODO: dispose collision object

// TODO: Set world properties

// TODO: Collision callbacks

// TODO: Create constraints

// Physics step
extern "C" FREObject DiscreteDynamicsWorldstepSimulation(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_timestep = argv[1];
    FREObject as3_maxsubsteps = argv[2];
    FREObject as3_fixedstep = argv[3];
    btDiscreteDynamicsWorld* dynamicsWorld;
    double timestep, fixedstep;
    int maxsubsteps;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsDouble(as3_timestep, &timestep);
    FREGetObjectAsInt32(as3_maxsubsteps, &maxsubsteps);
    FREGetObjectAsDouble(as3_fixedstep, &fixedstep);
    
    dynamicsWorld->stepSimulation((btScalar)timestep, maxsubsteps, (btScalar)fixedstep);
    
    // TODO: worry about collision callbacks!
    return NULL;
}

