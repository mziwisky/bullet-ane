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
    FREObject as3_mass = argv[1];
    FREObject as3_inertia = argv[2];
    btCollisionShape* shape;
    double mass;
    
    FREGetObjectAsUint32(as3_shape, (uint32_t*)&shape);
    FREGetObjectAsDouble(as3_mass, &mass);
    
    bool isDynamic = (mass != 0.0f);
    
    btVector3 localInertia(0,0,0);
    if (as3_inertia)
        localInertia = vec3DToBtVector(as3_inertia);
    else if (isDynamic)
        shape->calculateLocalInertia((btScalar)mass, localInertia);
    
//    btMotionState* a3dMotionState = new Away3DMotionState(as3_skin);
    btMotionState* defaultMS = new btDefaultMotionState();
    btRigidBody::btRigidBodyConstructionInfo rbInfo((btScalar)mass, defaultMS, shape, localInertia);
    btRigidBody* body = new btRigidBody(rbInfo);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)body, &ptr);
    return ptr;
}

extern "C" FREObject RigidBodyapplyCentralImpulse(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::applyCentralImpulse);
}

extern "C" FREObject RigidBodysetLinearFactor(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::setLinearFactor);
}

extern "C" FREObject RigidBodysetAngularFactor(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::setAngularFactor);
}

extern "C" FREObject RigidBodygetLinearVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getVector3(argv[0], &btRigidBody::getLinearVelocity);
}

extern "C" FREObject RigidBodysetLinearVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::setLinearVelocity);
}

extern "C" FREObject RigidBodygetAngularVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getVector3(argv[0], &btRigidBody::getAngularVelocity);
}

extern "C" FREObject RigidBodysetAngularVelocity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::setAngularVelocity);
}

extern "C" FREObject RigidBodygetInvInertiaDiagLocal(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getVector3(argv[0], &btRigidBody::getInvInertiaDiagLocal);
}

extern "C" FREObject RigidBodyapplyCentralForce(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::applyCentralForce);
}

extern "C" FREObject RigidBodyapplyTorque(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::applyTorque);
}

extern "C" FREObject RigidBodyapplyTorqueImpulse(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::applyTorqueImpulse);
}

extern "C" FREObject RigidBodygetGravity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getVector3(argv[0], &btRigidBody::getGravity);
}

extern "C" FREObject RigidBodysetGravity(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setVector3(argv, &btRigidBody::setGravity);
}

extern "C" FREObject RigidBodysetMassProps(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_mass = argv[1];
    FREObject as3_intertia = argv[2];
    btRigidBody* body;
    double mass;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsDouble(as3_mass, &mass);
    btVector3 inertia;
    if (as3_intertia) {
        inertia = vec3DToBtVector(as3_intertia);
    } else if (mass == 0.0) {
        inertia = btVector3(0,0,0);
    } else {
        body->getCollisionShape()->calculateLocalInertia(btScalar(mass), inertia);
    }
    body->setMassProps(btScalar(mass), inertia);
    body->updateInertiaTensor();
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

extern "C" FREObject RigidBodygetLinearDamping(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalar(argv[0], &btRigidBody::getLinearDamping);
}

extern "C" FREObject RigidBodysetLinearDamping(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_damping = argv[1];
    btRigidBody* body;
    double damping;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsDouble(as3_damping, &damping);
    body->setDamping(btScalar(damping), body->getAngularDamping());
    return NULL;
}

extern "C" FREObject RigidBodygetAngularDamping(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalar(argv[0], &btRigidBody::getAngularDamping);
}

extern "C" FREObject RigidBodysetAngularDamping(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_body = argv[0];
    FREObject as3_damping = argv[1];
    btRigidBody* body;
    double damping;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&body);
    FREGetObjectAsDouble(as3_damping, &damping);
    body->setDamping(body->getLinearDamping(), btScalar(damping));
    return NULL;
}


// TODO: destroy it