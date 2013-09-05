//
//  Generic6DofConstraintAPI.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 8/6/13.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"
#include "util.h"

extern "C" FREObject createGeneric6DofConstraint(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_rbA = argv[0];
    FREObject as3_rbB = argv[1];
    FREObject as3_frameInA = argv[2];
    FREObject as3_frameInB = argv[3];
    FREObject as3_useLinearReferenceFrameA = argv[4];
    btRigidBody *rbA, *rbB;
    uint32_t useLinearReferenceFrameA;
    
    FREGetObjectAsUint32(as3_rbA, (uint32_t*)&rbA);
    FREGetObjectAsUint32(as3_rbB, (uint32_t*)&rbB);
    btTransform frameInA = mat3DToBtTransform(as3_frameInA);
    btTransform frameInB = mat3DToBtTransform(as3_frameInB);
    FREGetObjectAsBool(as3_useLinearReferenceFrameA, &useLinearReferenceFrameA);
    
    btGeneric6DofConstraint* sixdof = new btGeneric6DofConstraint(*rbA, *rbB, frameInA, frameInB, useLinearReferenceFrameA);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)sixdof, &ptr);
    return ptr;
}

extern "C" FREObject Generic6DofConstraintsetLinearLimits(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_sixdof = argv[0];
    FREObject as3_lower = argv[1];
    FREObject as3_upper = argv[2];
    
    btGeneric6DofConstraint* sixdof;
    
    FREGetObjectAsUint32(as3_sixdof, (uint32_t*)&sixdof);
    sixdof->setLinearLowerLimit(vec3DToBtVector(as3_lower));
    sixdof->setLinearUpperLimit(vec3DToBtVector(as3_upper));
    return NULL;
}

extern "C" FREObject Generic6DofConstraintsetAngularLimits(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_sixdof = argv[0];
    FREObject as3_lower = argv[1];
    FREObject as3_upper = argv[2];
    
    btGeneric6DofConstraint* sixdof;
    
    FREGetObjectAsUint32(as3_sixdof, (uint32_t*)&sixdof);
    sixdof->setAngularLowerLimit(vec3DToBtVector(as3_lower));
    sixdof->setAngularUpperLimit(vec3DToBtVector(as3_upper));
    return NULL;
}
