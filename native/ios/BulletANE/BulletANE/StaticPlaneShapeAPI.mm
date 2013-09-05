//
//  StaticPlaneShapeAPI.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 7/3/13.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

extern "C" FREObject createStaticPlaneShape(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_a = argv[0];
    FREObject as3_b = argv[1];
    FREObject as3_c = argv[2];
    FREObject as3_d = argv[3];
    double a, b, c, d;
    
    FREGetObjectAsDouble(as3_a, &a);
    FREGetObjectAsDouble(as3_b, &b);
    FREGetObjectAsDouble(as3_c, &c);
    FREGetObjectAsDouble(as3_d, &d);
    
    btVector3 normal = btVector3((btScalar)a, (btScalar)b, (btScalar)c);
    btScalar constant = (btScalar)d;
    
    btCollisionShape* shape = new btStaticPlaneShape(normal, constant);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)shape, &ptr);
    return ptr;
}