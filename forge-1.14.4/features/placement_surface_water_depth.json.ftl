if (!(world.getBlockState(placePos).getBlock() == Blocks.WATER && world.getBlockState(placePos.down(${field$depth})).getBlock() == Blocks.WATER))
  return false;
