//
//  DiscreteDynamicsWorldAPI.cpp
//  BulletANE
//
//  Created by Michael Ziwisky on 7/1/13.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"
#include "BulletCollision/CollisionDispatch/btGhostObject.h"
#include "util.h"

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

void tickCallback(btDynamicsWorld *world, btScalar timeStep) {
    FREContext ctx = world->getWorldUserInfo();
    char strA[12], strB[12];
    // This is based on the tickCallback in AwayPhysics, but simplified.  It only reports
    // collisiont pairs, nothing about the contact manifold.  The idea is to dispatch
    // a status event with code=(objA ptr as String) and level=(objB ptr as String).
    
    int numManifolds = world->getDispatcher()->getNumManifolds();
    for (int i = 0; i < numManifolds; i++) {
        btPersistentManifold* contactManifold = world->getDispatcher()->getManifoldByIndexInternal(i);
        const btCollisionObject* obA = contactManifold->getBody0();
        const btCollisionObject* obB = contactManifold->getBody1();
        sprintf(strA, "%d", (unsigned int)obA);
        sprintf(strB, "%d", (unsigned int)obB);
        
        if (obA->getCollisionFlags() & btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK) {
            FREDispatchStatusEventAsync(ctx, (uint8_t*)strA, (uint8_t*)strB);
        }
        if (obB->getCollisionFlags() & btCollisionObject::CF_CUSTOM_MATERIAL_CALLBACK) {
            FREDispatchStatusEventAsync(ctx, (uint8_t*)strB, (uint8_t*)strA);
        }
    }
}

extern "C" FREObject DiscreteDynamicsWorldsetCollisionCallback(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_turnon = argv[1];
    btDiscreteDynamicsWorld* dynamicsWorld;
    uint32_t turnon;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsBool(as3_turnon, &turnon);
    
    if (turnon) dynamicsWorld->setInternalTickCallback(tickCallback, ctx, true);
    else dynamicsWorld->setInternalTickCallback(NULL, NULL, true);
    return NULL;
}

extern "C" FREObject disposeDynamicsWorld(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    btDiscreteDynamicsWorld* dynamicsWorld;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    
    delete dynamicsWorld;
    return NULL;
}

extern "C" FREObject DiscreteDynamicsWorldaddRigidBody(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_body = argv[1];
    FREObject as3_group = argv[2];
    FREObject as3_mask = argv[3];
    btDiscreteDynamicsWorld* dynamicsWorld;
    btRigidBody* body;
    int group, mask;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsInt32(as3_group, &group);
    FREGetObjectAsInt32(as3_mask, &mask);
    
    dynamicsWorld->addRigidBody(body, group, mask);
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

// TODO: Collision callbacks

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

extern "C" FREObject DiscreteDynamicsWorldaddConstraint(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_constraint = argv[1];
    FREObject as3_disableCollisions = argv[2];
    btDiscreteDynamicsWorld* dynamicsWorld;
    btTypedConstraint* constraint;
    uint32_t disableCollisions;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsUint32(as3_constraint, (uint32_t*)&constraint);
    FREGetObjectAsBool(as3_disableCollisions, &disableCollisions);
    
    dynamicsWorld->addConstraint(constraint, disableCollisions);
    return NULL;
}

extern "C" FREObject DiscreteDynamicsWorldremoveConstraint(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_constraint = argv[1];
    btDiscreteDynamicsWorld* dynamicsWorld;
    btTypedConstraint* constraint;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&dynamicsWorld);
    FREGetObjectAsUint32(as3_constraint, (uint32_t*)&constraint);
    
    dynamicsWorld->removeConstraint(constraint);
    return NULL;
}

extern "C" FREObject DiscreteDynamicsWorldsetGravity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btDiscreteDynamicsWorld::setGravity);
}

extern "C" FREObject DiscreteDynamicsWorldgetGravity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getVector3(argv[0], &btDiscreteDynamicsWorld::getGravity);
}
