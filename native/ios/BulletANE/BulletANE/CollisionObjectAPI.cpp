//
//  BoxShapeAPI.cpp
//  BulletANE
//
//  Created by Michael Ziwisky on 7/3/13.
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
    FRENewObjectFromUint32((uint32_t)(size_t)obj, &ptr);
    return ptr;
}

extern "C" FREObject CollisionObjectgetCollisionFlags(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getInt(argv[0], &btCollisionObject::getCollisionFlags);
}

extern "C" FREObject CollisionObjectsetCollisionFlags(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setInt(argv, &btCollisionObject::setCollisionFlags);
}

extern "C" FREObject CollisionObjectgetRestitution(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalar(argv[0], &btCollisionObject::getRestitution);
}

extern "C" FREObject CollisionObjectsetRestitution(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setRestitution);
}

extern "C" FREObject CollisionObjectgetFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalar(argv[0], &btCollisionObject::getFriction);
}

extern "C" FREObject CollisionObjectsetFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setFriction);
}

extern "C" FREObject CollisionObjectgetRollingFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalar(argv[0], &btCollisionObject::getRollingFriction);
}

extern "C" FREObject CollisionObjectsetRollingFriction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setRollingFriction);
}

extern "C" FREObject CollisionObjectgetHitFraction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getScalar(argv[0], &btCollisionObject::getHitFraction);
}

extern "C" FREObject CollisionObjectsetHitFraction(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setHitFraction);
}

extern "C" FREObject CollisionObjectgetActivationState(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return getInt(argv[0], &btCollisionObject::getActivationState);
}

extern "C" FREObject CollisionObjectsetActivationState(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setInt(argv, &btCollisionObject::setActivationState);
}

extern "C" FREObject CollisionObjectforceActivationState(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setInt(argv, &btCollisionObject::forceActivationState);
}

extern "C" FREObject CollisionObjectsetCcdSweptSphereRadius(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setCcdSweptSphereRadius);
}

extern "C" FREObject CollisionObjectsetCcdMotionThreshold(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    return setScalar(argv, &btCollisionObject::setCcdMotionThreshold);
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
