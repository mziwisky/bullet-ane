//
//  debug.mm
//  BulletANE
//
//  Created by Michael Ziwisky on 7/10/13.
//

#include "FlashRuntimeExtensions.h"
#include "btBulletDynamicsCommon.h"
#include "debug.h"

extern "C" void printShit(char *shit) {
    NSLog(@"%s", shit);
}

extern "C" void print16scalars(btScalar *d) {
    NSLog(@"%f, %f, %f, %f\n%f, %f, %f, %f\n%f, %f, %f, %f\n%f, %f, %f, %f\n",
          double(d[0]), double(d[4]), double(d[8]), double(d[12]),
          double(d[1]), double(d[5]), double(d[9]), double(d[13]),
          double(d[2]), double(d[6]), double(d[10]), double(d[14]),
          double(d[3]), double(d[7]), double(d[11]), double(d[15]));
}

extern "C" void printResult(FREResult res, char *note, boolean_t evenIfOK) {
    switch (res) {
        case FRE_OK:
            if (evenIfOK) {
                NSLog(@"%s: OK", note);
            }
            break;
        case FRE_NO_SUCH_NAME:
            NSLog(@"%s: NO SUCH NAME", note);
            break;
        case FRE_INVALID_OBJECT:
            NSLog(@"%s: INVALID OBJECT", note);
            break;
        case FRE_TYPE_MISMATCH:
            NSLog(@"%s: TYPE MISMATCH", note);
            break;
        case FRE_ACTIONSCRIPT_ERROR:
            NSLog(@"%s: ACTIONSCRIPT ERROR", note);
            break;
        case FRE_INVALID_ARGUMENT:
            NSLog(@"%s: INVALID ARGUMENT", note);
            break;
        case FRE_READ_ONLY:
            NSLog(@"%s: READ ONLY", note);
            break;
        case FRE_WRONG_THREAD:
            NSLog(@"%s: WRONG THREAD", note);
            break;
        case FRE_ILLEGAL_STATE:
            NSLog(@"%s: ILLEGAL STATE", note);
            break;
        case FRE_INSUFFICIENT_MEMORY:
            NSLog(@"%s: INSUFFICIENT MEMORY", note);
            break;
            
        default:
            break;
    }
}
