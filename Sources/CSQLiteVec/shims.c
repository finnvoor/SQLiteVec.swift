#include "sqlite3.h"
#include "sqlite-vec.h"

int sqlite3_auto_extension_vec_init() {
  return sqlite3_auto_extension((void *)sqlite3_vec_init);
}
