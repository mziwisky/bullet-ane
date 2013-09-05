//
//  SphereShapeAPI.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 7/3/13.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

extern "C" FREObject createSphereShape(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_rad = argv[0];
    double rad;
    
    FREGetObjectAsDouble(as3_rad, &rad);
    
    btCollisionShape* shape = new btSphereShape((btScalar)rad);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)shape, &ptr);
    return ptr;
}

