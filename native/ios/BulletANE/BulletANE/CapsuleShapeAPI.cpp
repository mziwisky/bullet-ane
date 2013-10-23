//
//  CapsuleShapeAPI.cpp
//  BulletANE
//
//  Created by Michael Ziwisky on 7/12/13.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

extern "C" FREObject createCapsuleShape(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_rad = argv[0];
    FREObject as3_height = argv[1];
    double rad, height;
    
    FREGetObjectAsDouble(as3_rad, &rad);
    FREGetObjectAsDouble(as3_height, &height);
    
    btCollisionShape* shape = new btCapsuleShape(btScalar(rad), btScalar(height));
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)shape, &ptr);
    return ptr;
}

// TODO: property getters/setters

// TODO: disposal