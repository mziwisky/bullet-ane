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


// TODO: collision callbacks!
