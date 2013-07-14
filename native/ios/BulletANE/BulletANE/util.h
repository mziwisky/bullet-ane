//
//  util.h
//  BulletANE
//
//  Created by Michael Ziwisky on 7/10/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#ifndef BulletANE_util_h
#define BulletANE_util_h

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

btTransform mat3DToBtTransform(FREObject);
FREObject btTransformToMat3D(btTransform&);
btVector3 vec3DToBtVector(FREObject);
FREObject btVectorToVec3D(btVector3);

#endif
