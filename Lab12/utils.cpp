#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t numtag = cache_config.get_num_tag_bits();
  uint32_t result = address>>(32-numtag);
  
  return result;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t tag = cache_config.get_num_tag_bits();
  uint32_t offset = cache_config.get_num_block_offset_bits();
  uint32_t ones = (1<<(32-tag))-1;
  uint32_t newaddress = address&ones;
  newaddress = newaddress>>offset;
  
  return newaddress;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  uint32_t offset = cache_config.get_num_block_offset_bits();
  uint32_t ones = (1<<offset)-1;
  uint32_t newaddress=address&ones;
    
  return newaddress;
}
