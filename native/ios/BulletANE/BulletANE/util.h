//
//  util.h
//  BulletANE
//
//  Created by Michael Ziwisky on 7/10/13.
//

#ifndef BulletANE_util_h
#define BulletANE_util_h

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

btTransform mat3DToBtTransform(FREObject);
FREObject btTransformToMat3D(btTransform&);
btVector3 vec3DToBtVector(FREObject);
FREObject btVectorToVec3D(btVector3);

// Oh my goodness, the following helper functions are *so* C++.  I am *such* a boss.
template <class btClass> FREObject setScalar(FREObject argv[], void (btClass::*setter)(btScalar));
template <class btClass> FREObject getScalar(FREObject as3_obj, btScalar (btClass::*getter)(void) const);
template <class btClass> FREObject setInt(FREObject argv[], void (btClass::*setter)(int));
template <class btClass> FREObject setInt(FREObject argv[], void (btClass::*setter)(int) const);
template <class btClass> FREObject getInt(FREObject as3_obj, int (btClass::*getter)(void) const);
template <class btClass> FREObject setVector3(FREObject argv[], void (btClass::*setter)(const btVector3&));
template <class btClass> FREObject getVector3(FREObject as3_obj, const btVector3& (btClass::*getter)(void) const);
template <class btClass> FREObject getVector3(FREObject as3_obj, btVector3 (btClass::*getter)(void) const);

template <class btClass>
FREObject setScalar(FREObject argv[], void (btClass::*setter)(btScalar)) {
    FREObject as3_body = argv[0];
    FREObject as3_val = argv[1];
    btClass* obj;
    double val;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&obj);
    FREGetObjectAsDouble(as3_val, &val);
    
    (obj->*setter)(btScalar(val));
    return NULL;
}

template <class btClass>
FREObject getScalar(FREObject as3_obj, btScalar (btClass::*getter)(void) const) {
    btClass* obj;
    FREObject as3_val;
    btScalar val;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    val = (obj->*getter)();
    
    FRENewObjectFromDouble(double(val), &as3_val);
    return as3_val;
}

template <class btClass>
FREObject setInt(FREObject argv[], void (btClass::*setter)(int))
{
    FREObject as3_obj = argv[0];
    FREObject as3_val = argv[1];
    btClass* obj;
    uint32_t val;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    FREGetObjectAsUint32(as3_val, &val);
    
    (obj->*setter)(int(val));
    return NULL;
}

template <class btClass>
FREObject setInt(FREObject argv[], void (btClass::*setter)(int) const)
{
    return setInt(argv, (void (btClass::*)(int))setter);
}

template <class btClass>
FREObject getInt(FREObject as3_obj, int (btClass::*getter)(void) const)
{
    btClass* obj;
    FREObject as3_val;
    int val;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    val = (obj->*getter)();
    
    FRENewObjectFromInt32(int32_t(val), &as3_val);
    return as3_val;
}

template <class btClass>
FREObject setVector3(FREObject argv[], void (btClass::*setter)(const btVector3&))
{
    FREObject as3_body = argv[0];
    FREObject as3_val = argv[1];
    btClass* obj;
    
    FREGetObjectAsUint32(as3_body, (uint32_t*)&obj);
    
    (obj->*setter)(vec3DToBtVector(as3_val));
    return NULL;
}

template <class btClass>
FREObject getVector3(FREObject as3_obj, const btVector3& (btClass::*getter)(void) const)
{
    btClass* obj;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    return btVectorToVec3D((obj->*getter)());
}

template <class btClass>
FREObject getVector3(FREObject as3_obj, btVector3 (btClass::*getter)(void) const)
{
    btClass* obj;
    
    FREGetObjectAsUint32(as3_obj, (uint32_t*)&obj);
    return btVectorToVec3D((obj->*getter)());
}

#endif
