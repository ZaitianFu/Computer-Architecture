#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t offset = _cache_config.get_num_block_offset_bits();
  uint32_t idx=_cache_config.get_num_index_bits();
  uint32_t tag0=_tag<<(idx+offset);
  uint32_t ret=tag0 |(_index<<offset);
  
  return ret;
}
