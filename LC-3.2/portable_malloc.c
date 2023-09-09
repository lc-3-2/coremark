#include <stdlib.h>
#include "coremark.h"

void *portable_malloc(ee_size_t size) { return malloc(size); }
void portable_free(void *p) { free(p); }
