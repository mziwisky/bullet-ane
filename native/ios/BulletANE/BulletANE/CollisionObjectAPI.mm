//
//  BoxShapeAPI.cpp
//  BulletANE
//
//  Created by Michael Ziwisky on 7/3/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"
#include "util.h"

extern "C" FREObject createCollisionObject(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_shape = argv[0];
    uint32_t shapePtr;
    
    FREGetObjectAsUint32(as3_shape, &shapePtr);
    
    btCollisionObject* obj = new btCollisionObject();
    obj->setCollisionShape((btCollisionShape*)shapePtr);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)obj, &ptr);
    return ptr;
}

FREObject setScalar(FREObject argv[], void (btCollisionObject::*setter)(btScalar))
{
    FREObject as3_obj = argv[0];
    FREObject as3_val = argv[1];
    btCollisionObject* obj;
    double val;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    FREGetObjectAsDouble(as3_val, &val);
    
    (obj->*setter)(btScalar(val));
    return NULL;
}

FREObject getScalarConst(FREObject as3_obj, btScalar (btCollisionObject::*getter)(void) const)
{
    btCollisionObject* obj;
    FREObject as3_val;
    btScalar val;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    val = (obj->*getter)();
    
    FRENewObjectFromDouble(double(val), &as3_val);
    return as3_val;
}

FREObject setInt(FREObject argv[], void (btCollisionObject::*setter)(int))
{
    FREObject as3_obj = argv[0];
    FREObject as3_val = argv[1];
    btCollisionObject* obj;
    uint32_t val;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    FREGetObjectAsUint32(as3_val, &val);
    
    (obj->*setter)(int(val));
    return NULL;
}

FREObject getIntConst(FREObject as3_obj, int (btCollisionObject::*getter)(void) const)
{
    btCollisionObject* obj;
    FREObject as3_val;
    int val;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    val = (obj->*getter)();
    
    FRENewObjectFromInt32(int32_t(val), &as3_val);
    return as3_val;
}

FREObject setIntConst(FREObject argv[], void (btCollisionObject::*setter)(int) const)
{
    return setInt(argv, (void (btCollisionObject::*)(int))setter);
}

extern "C" FREObject CollisionObjectgetCollisionFlags(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getIntConst(argv[0], &btCollisionObject::getCollisionFlags);
}

extern "C" FREObject CollisionObjectsetCollisionFlags(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setInt(argv, &btCollisionObject::setCollisionFlags);
}

extern "C" FREObject CollisionObjectgetRestitution(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalarConst(argv[0], &btCollisionObject::getRestitution);
}

extern "C" FREObject CollisionObjectsetRestitution(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setRestitution);
}

extern "C" FREObject CollisionObjectgetFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalarConst(argv[0], &btCollisionObject::getFriction);
}

extern "C" FREObject CollisionObjectsetFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setFriction);
}

extern "C" FREObject CollisionObjectgetRollingFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalarConst(argv[0], &btCollisionObject::getRollingFriction);
}

extern "C" FREObject CollisionObjectsetRollingFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setRollingFriction);
}

extern "C" FREObject CollisionObjectgetHitFraction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalarConst(argv[0], &btCollisionObject::getHitFraction);
}

extern "C" FREObject CollisionObjectsetHitFraction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setHitFraction);
}

extern "C" FREObject CollisionObjectgetActivationState(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getIntConst(argv[0], &btCollisionObject::getActivationState);
}

extern "C" FREObject CollisionObjectsetActivationState(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setIntConst(argv, &btCollisionObject::setActivationState);
}

extern "C" FREObject CollisionObjectforceActivationState(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setIntConst(argv, &btCollisionObject::forceActivationState);
}

extern "C" FREObject CollisionObjectgetCollisionFilterGroup(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_obj = argv[0];
    btCollisionObject* obj;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    short group = obj->getBroadphaseHandle()->m_collisionFilterGroup;
    FREObject as3_group;
    FRENewObjectFromInt32((int32_t)group, &as3_group);
    return as3_group;
}

extern "C" FREObject CollisionObjectgetCollisionFilterMask(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_obj = argv[0];
    btCollisionObject* obj;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    short mask = obj->getBroadphaseHandle()->m_collisionFilterMask;
    FREObject as3_mask;
    FRENewObjectFromInt32((int32_t)mask, &as3_mask);
    return as3_mask;
}

extern "C" FREObject CollisionObjectgetWorldTransform(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_obj = argv[0];
    btCollisionObject* obj;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    
    FREObject mat3d = btTransformToMat3D(obj->getWorldTransform());
    return mat3d;
}

extern "C" FREObject CollisionObjectsetWorldTransform(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_obj = argv[0];
    FREObject as3_trans = argv[1];
    btCollisionObject* obj;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    
    obj->setWorldTransform(mat3DToBtTransform(as3_trans));
    return NULL;
}

extern "C" FREObject CollisionObjectactivate(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_obj = argv[0];
    FREObject as3_forceit = argv[1];
    btCollisionObject* obj;
    uint32_t forceit;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    FREGetObjectAsBool(as3_forceit, &forceit);
    
    obj->activate(forceit);
    return NULL;
}


// TODO: collision callbacks!
