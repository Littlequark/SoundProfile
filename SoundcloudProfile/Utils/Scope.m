//
//Scope.m
//

#import "Scope.h"

void ext_executeCleanupBlock (__strong ext_cleanupBlock_t *block) {
    (*block)();
}
