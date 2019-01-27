#include <algorithm>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "transpose.h"

// will be useful
// remember that you shouldn't go over SIZE
using std::min;

// modify this function to add tiling
void transpose_tiled(int **src, int **dest) {
  int tilesize=40;
    for (int i = 0; i < SIZE; i +=tilesize) {
        for (int j = 0; j < SIZE; j +=tilesize) {
          int newi=min(i+tilesize, SIZE);
          int newj=min(j+tilesize, SIZE);
          for (int ii=i; ii<newi; ii++){
            for (int jj=j; jj<newj; jj++)
              dest[ii][jj] = src[jj][ii];
          }
        }
    }
}
