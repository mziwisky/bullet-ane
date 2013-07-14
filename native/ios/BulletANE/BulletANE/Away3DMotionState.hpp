//
//  Away3DMotionState.hpp
//  BulletANE
//
//  Created by Michael Ziwisky on 7/9/13.
//  Copyright (c) 2013 Glimce. All rights reserved.
//

#ifndef __BulletANE__Away3DMotionState__
#define __BulletANE__Away3DMotionState__

#include <iostream>
#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

#include "debug.h"

class Away3DMotionState : public btMotionState {
public:
    Away3DMotionState(FREObject a3dskin) {
        this->skin = a3dskin;
    }
    
    virtual ~Away3DMotionState() {
    }
    
    virtual void getWorldTransform(btTransform &worldTrans) const {
        FREObject trans, raw;
        FREGetObjectProperty(skin, (uint8_t*)"transform", &trans, NULL);
        FREGetObjectProperty(trans, (uint8_t*)"rawData", &raw, NULL);
        
        btScalar data[16];
        for (int i=0; i < 16; i++) {
            FREObject val;
            double dval;
            FREGetArrayElementAt(raw, i, &val);
            FREGetObjectAsDouble(val, &dval);
            data[i] = btScalar(dval);
        }
        worldTrans.setFromOpenGLMatrix(data);
    }
    
    virtual void setWorldTransform(const btTransform &worldTrans) {
        printShit("Should set transform...");
        FREObject raw, trans;
        FRENewObject((uint8_t*)"Vector.<Number>", 0, NULL, &raw, NULL);
        FRESetArrayLength(raw, 16);
        
        btScalar data[16];
        worldTrans.getOpenGLMatrix(data);
        printShit("Data: ");
        print16scalars(data);
        for (int i=0; i < 16; i++) {
            FREObject val;
            printResult(FRENewObjectFromDouble(double(data[i]), &val), "Make double", false);
            printResult(FRESetArrayElementAt(raw, i, val), "Set arr elem", false);
        }
        printResult(FRENewObject((uint8_t*)"flash.geom.Matrix3D", 0, NULL, &trans, NULL), "New Mat3D", false);
        printResult(FRESetObjectProperty(trans, (uint8_t*)"rawData", raw, NULL), "Set rawData", false);
        printResult(FRESetObjectProperty(skin, (uint8_t*)"transform", trans, NULL), "Set transform", false);
    }
    
protected:
    FREObject skin;
};

#endif /* defined(__BulletANE__Away3DMotionState__) */
