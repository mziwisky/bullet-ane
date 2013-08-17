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
//    FREObject as3_skinTransform = argv[1];
    FREObject as3_mass = argv[1];
    btCollisionShape* shape;
    double mass;
    
    FREGetObjectAsUint32(as3_shape, (uint32_t*)&shape);
    FREGetObjectAsDouble(as3_mass, &mass);
    
    bool isDynamic = (mass != 0.0f);
    
    btVector3 localInertia(0,0,0);
    if (isDynamic)
        shape->calculateLocalInertia((btScalar)mass, localInertia);
    
//    btMotionState* a3dMotionState = new Away3DMotionState(as3_skin);
//    btMotionState* defaultMS = new btDefaultMotionState(mat3DToBtTransform(as3_skinTransform));
    btMotionState* defaultMS = new btDefaultMotionState();
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
    body->applyCentralImpulse(vec3DToBtVector(as3_impulse));
    return NULL;
}

extern "C" FREObject RigidBodysetLinearFactor(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_factor = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    body->setLinearFactor(vec3DToBtVector(as3_factor));
    return NULL;
}

extern "C" FREObject RigidBodysetAngularFactor(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_factor = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    body->setAngularFactor(vec3DToBtVector(as3_factor));
    return NULL;
}

extern "C" FREObject RigidBodygetLinearVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    
    return btVectorToVec3D(body->getLinearVelocity());
}

extern "C" FREObject RigidBodysetLinearVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_linvel = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    body->setLinearVelocity(vec3DToBtVector(as3_linvel));
    return NULL;
}

extern "C" FREObject RigidBodygetAngularVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    
    return btVectorToVec3D(body->getAngularVelocity());
}


extern "C" FREObject RigidBodysetAngularVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_linvel = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    body->setAngularVelocity(vec3DToBtVector(as3_linvel));
    return NULL;
}

extern "C" FREObject RigidBodysetMass(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_mass = argv[1];
    btRigidBody* body;
    double mass;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsDouble(as3_mass, &mass);
    btVector3 inertia;
    if (mass == 0.0) {
        inertia = btVector3(0,0,0);
    } else {
        body->getCollisionShape()->calculateLocalInertia(btScalar(mass), inertia);
    }
    body->setMassProps(btScalar(mass), inertia);
    return NULL;
}

extern "C" FREObject RigidBodyapplyCentralForce(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_force = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    body->applyCentralForce(vec3DToBtVector(as3_force));
    return NULL;
}

extern "C" FREObject RigidBodyapplyTorque(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_torque = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    body->applyTorque(vec3DToBtVector(as3_torque));
    return NULL;
}

extern "C" FREObject RigidBodyapplyTorqueImpulse(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_impulse = argv[1];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    body->applyTorqueImpulse(vec3DToBtVector(as3_impulse));
    return NULL;
}

extern "C" FREObject RigidBodyaddConstraintRef(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_constraint = argv[1];
    btRigidBody* body;
    btTypedConstraint* constraint;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsUint32(as3_constraint, (uint32_t*)&constraint);
    body->addConstraintRef(constraint);
    return NULL;
}

extern "C" FREObject RigidBodyremoveConstraintRef(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_constraint = argv[1];
    btRigidBody* body;
    btTypedConstraint* constraint;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsUint32(as3_constraint, (uint32_t*)&constraint);
    body->removeConstraintRef(constraint);
    return NULL;
}

extern "C" FREObject RigidBodygetConstraintRef(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_index = argv[1];
    btRigidBody* body;
    uint32_t index;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsUint32(as3_index, &index);
    btTypedConstraint* ref = body->getConstraintRef(index);
    
    FREObject as3ref;
    FRENewObjectFromUint32((uint32_t)ref, &as3ref);
    return as3ref;
}

extern "C" FREObject RigidBodygetNumConstraintRefs(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    btRigidBody* body;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    uint32_t num = body->getNumConstraintRefs();
    
    FREObject as3num;
    FRENewObjectFromUint32(num, &as3num);
    return as3num;
}


// TODO: destroy it