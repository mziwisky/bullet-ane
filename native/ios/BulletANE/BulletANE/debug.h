//
//  debug.h
//  BulletANE
//
//  Created by Michael Ziwisky on 7/10/13.
//

#ifndef BulletANE_debug_h
#define BulletANE_debug_h

// Just some debugging hooks that let pure C++ code write shit to NSLog
#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"

void printShit(char*);
void print16scalars(btScalar*);
void printResult(FREResult, char*, boolean_t);

#endif
