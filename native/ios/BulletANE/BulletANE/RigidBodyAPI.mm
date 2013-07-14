//
//  RigidBodyAPI.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 7/3/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"
#include "util.h"

extern "C" FREObject createRigidBody(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_shape = argv[0];
    FREObject as3_skinTransform = argv[1];
    FREObject as3_mass = argv[2];
    btCollisionShape* shape;
    double mass;
    
    FREGetObjectAsUint32(as3_shape, (uint32_t*)&shape);
    FREGetObjectAsDouble(as3_mass, &mass);
    
    bool isDynamic = (mass != 0.0f);
    
    btVector3 localInertia(0,0,0);
    if (isDynamic)
        shape->calculateLocalInertia((btScalar)mass, localInertia);
    
//    btMotionState* a3dMotionState = new Away3DMotionState(as3_skin);
    btMotionState* defaultMS = new btDefaultMotionState(mat3DToBtTransform(as3_skinTransform));
    btRigidBody::btRigidBodyConstructionInfo rbInfo((btScalar)mass, defaultMS, shape, localInertia);
    btRigidBody* body = new btRigidBody(rbInfo);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)body, &ptr);
    return ptr;
}

extern "C" FREObject RigidBodyapplyCentralImpulse(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_impulse = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    btVector3 impulse = vec3DToBtVector(as3_impulse);
    body->applyCentralImpulse(impulse);
    return NULL;
}

extern "C" FREObject RigidBodysetLinearFactor(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_factor = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    btVector3 factor = vec3DToBtVector(as3_factor);
    body->setLinearFactor(factor);
    return NULL;
}

extern "C" FREObject RigidBodysetAngularFactor(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_factor = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    btVector3 factor = vec3DToBtVector(as3_factor);
    body->setAngularFactor(factor);
    return NULL;
}

extern "C" FREObject RigidBodygetLinearVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    
    return btVectorToVec3D(body->getLinearVelocity());
}

// TODO: Modify RigidBody properties
// TODO: destroy it