//
//  util.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 7/10/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#include "util.h"

btTransform mat3DToBtTransform(FREObject mat3d)
{
    FREObject raw;
    FREGetObjectProperty(mat3d, (uint8_t*)"rawData", &raw, NULL);
    
    btScalar data[16];
    for (int i=0; i < 16; i++) {
        FREObject val;
        double dval;
        FREGetArrayElementAt(raw, i, &val);
        FREGetObjectAsDouble(val, &dval);
        data[i] = btScalar(dval);
    }
    
    btTransform t;
    t.setFromOpenGLMatrix(data);
    return t;
}

FREObject btTransformToMat3D(btTransform& trans)
{
    FREObject mat3d, raw;
    FRENewObject((uint8_t*)"Vector.<Number>", 0, NULL, &raw, NULL);
    FRESetArrayLength(raw, 16);
    
    btScalar data[16];
    trans.getOpenGLMatrix(data);
    for (int i=0; i < 16; i++) {
        FREObject val;
        FRENewObjectFromDouble(double(data[i]), &val);
        FRESetArrayElementAt(raw, i, val);
    }
    
    FRENewObject((uint8_t*)"flash.geom.Matrix3D", 0, NULL, &mat3d, NULL);
    FRESetObjectProperty(mat3d, (uint8_t*)"rawData", raw, NULL);
    return mat3d;
}

btVector3 vec3DToBtVector(FREObject vec3d)
{
    FREObject val;
    double dval;
    btVector3 v;
    
    FREGetObjectProperty(vec3d, (uint8_t*)"x", &val, NULL);
    FREGetObjectAsDouble(val, &dval);
    v.setX(btScalar(dval));
    
    FREGetObjectProperty(vec3d, (uint8_t*)"y", &val, NULL);
    FREGetObjectAsDouble(val, &dval);
    v.setY(btScalar(dval));
    
    FREGetObjectProperty(vec3d, (uint8_t*)"z", &val, NULL);
    FREGetObjectAsDouble(val, &dval);
    v.setZ(btScalar(dval));
    
    FREGetObjectProperty(vec3d, (uint8_t*)"w", &val, NULL);
    FREGetObjectAsDouble(val, &dval);
    v.setW(btScalar(dval));
    
    return v;
}

FREObject btVectorToVec3D(btVector3 vec)
{
    FREObject vec3d, raw[4];
    
    FRENewObjectFromDouble(double(vec.x()), &(raw[0]));
    FRENewObjectFromDouble(double(vec.y()), &(raw[1]));
    FRENewObjectFromDouble(double(vec.z()), &(raw[2]));
    FRENewObjectFromDouble(double(vec.w()), &(raw[3]));
    
    FRENewObject((uint8_t*)"flash.geom.Vector3D", 4, raw, &vec3d, NULL);
    return vec3d;
}