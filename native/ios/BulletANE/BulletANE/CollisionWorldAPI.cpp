//
//  CollisionWorldAPI.cpp
//  BulletANE
//
//  Created by Michael Ziwisky on 9/13/13.
//

#include "FlashRuntimeExtensions.h"
#include "BulletCollision/CollisionDispatch/btGhostObject.h"
#include "util.h"

extern "C" FREObject createCollisionWorldWithDbvt(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    btDefaultCollisionConfiguration* collisionConfiguration = new btDefaultCollisionConfiguration();
    btCollisionDispatcher* dispatcher = new btCollisionDispatcher(collisionConfiguration);
    btBroadphaseInterface* overlappingPairCache = new btDbvtBroadphase();
    overlappingPairCache->getOverlappingPairCache()->setInternalGhostPairCallback(new btGhostPairCallback());
    
    btCollisionWorld* world = new btCollisionWorld(dispatcher, overlappingPairCache, collisionConfiguration);
    
    FREObject ptr;
    FRENewObjectFromUint32((uint32_t)world, &ptr);
    return ptr;
}

extern "C" FREObject CollisionWorldaddCollisionObject(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_object = argv[1];
    FREObject as3_group = argv[2];
    FREObject as3_mask = argv[3];
    btCollisionWorld* world;
    btCollisionObject* object;
    int group, mask;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&world);
    FREGetObjectAsUint32(as3_object, (uint32_t*)&object);
    FREGetObjectAsInt32(as3_group, &group);
    FREGetObjectAsInt32(as3_mask, &mask);
    
    world->addCollisionObject(object, group, mask);
    return NULL;
}

extern "C" FREObject CollisionWorldremoveCollisionObject(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_object = argv[1];
    btCollisionWorld* world;
    btCollisionObject* object;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&world);
    FREGetObjectAsUint32(as3_object, (uint32_t*)&object);
    
    world->removeCollisionObject(object);
    return NULL;
}

struct UniqueObjectsCallback : public btCollisionWorld::ContactResultCallback {
    btAlignedObjectArray<const btCollisionObject*> otherObjs;
    
    UniqueObjectsCallback(btCollisionObject* tgtObj) {
        m_collisionFilterGroup = tgtObj->getBroadphaseHandle()->m_collisionFilterGroup;
        m_collisionFilterMask = tgtObj->getBroadphaseHandle()->m_collisionFilterMask;
    }
    
    virtual btScalar addSingleResult(btManifoldPoint& cp,
                                     const btCollisionObjectWrapper* colObj0,int partId0,int index0,
                                     const btCollisionObjectWrapper* colObj1,int partId1,int index1)
    {
        // Some pairs of colliding btCollisionObjects may produce multiple ManifoldPoints, so this may be
        // called multiple times per pair of CollisionObjects. I only care about unique objects, so reject
        // duplicates.
        
        // TODO: consider using binarySearch (and quickSort) to speed it up.
        if (otherObjs.findLinearSearch(colObj0->getCollisionObject()) == otherObjs.size()) {
            otherObjs.push_back(colObj0->getCollisionObject());
        }
        
        return 0;
    }
};

extern "C" FREObject CollisionWorldcontactTest(FREContext ctx, void *funcData, uint32_t argc, FREObject argv[])
{
    FREObject as3_world = argv[0];
    FREObject as3_object = argv[1];
    btCollisionWorld* world;
    btCollisionObject* object;
    
    FREGetObjectAsUint32(as3_world, (uint32_t*)&world);
    FREGetObjectAsUint32(as3_object, (uint32_t*)&object);
    
    UniqueObjectsCallback cb(object);
    world->contactTest(object, cb);

    int numCol = cb.otherObjs.size();
    if (!numCol) return NULL;
    else {
        FREObject result;
        FRENewObject((uint8_t*)"Vector.<uint>", 0, NULL, &result, NULL);
        FRESetArrayLength(result, numCol);
        for (int i=0; i < numCol; i++) {
            FREObject objptr;
            FRENewObjectFromUint32(uint32_t(cb.otherObjs[i]), &objptr);
            FRESetArrayElementAt(result, i, objptr);
        }
        return result;
    }
}

