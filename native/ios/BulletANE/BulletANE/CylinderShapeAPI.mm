//
//  CylinderShapeAPI.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 7/12/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

extern "C" FREObject createCylinderShape(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_xSz = argv[0];
    FREObject as3_ySz = argv[1];
    FREObject as3_zSz = argv[2];
    double xSz, ySz, zSz;
    
    FREGetObjectAsDouble(as3_xSz, &xSz);
    FREGetObjectAsDouble(as3_ySz, &ySz);
    FREGetObjectAsDouble(as3_zSz, &zSz);
    
    btVector3 halfExtents = btVector3((btScalar)xSz/2, (btScalar)ySz/2, (btScalar)zSz/2);
    
    btCollisionShape* shape = new btCylinderShape(halfExtents);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)shape, &ptr);
    return ptr;
}

// TODO: property getters/setters

// TODO: disposal