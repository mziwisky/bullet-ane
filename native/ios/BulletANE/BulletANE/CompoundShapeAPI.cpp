//
//  CompoundShapeAPI.cpp
//  BulletANE
//
//  Created by Michael Ziwisky on 7/12/13.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"
#include "util.h"

extern "C" FREObject createCompoundShape(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    btCollisionShape* shape = new btCompoundShape();
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)shape, &ptr);
    return ptr;
}

extern "C" FREObject CompoundShapeaddChildShape(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_cshape = argv[0];
    FREObject as3_shape = argv[1];
    FREObject as3_trans = argv[2];
    btCompoundShape* cshape;
    btCollisionShape* shape;
    
    FREGetObjectAsUint32(as3_cshape, (uint32_t*)&cshape);
    FREGetObjectAsUint32(as3_shape, (uint32_t*)&shape);
    btTransform trans = mat3DToBtTransform(as3_trans);
    
    cshape->addChildShape(trans, shape);
    return NULL;
}

extern "C" FREObject CompoundShaperemoveChildShape(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_cshape = argv[0];
    FREObject as3_shape = argv[1];
    btCompoundShape* cshape;
    btCollisionShape* shape;
    
    FREGetObjectAsUint32(as3_cshape, (uint32_t*)&cshape);
    FREGetObjectAsUint32(as3_shape, (uint32_t*)&shape);
    
    cshape->removeChildShape(shape);
    return NULL;
}

// TODO: property getters/setters

// TODO: disposal