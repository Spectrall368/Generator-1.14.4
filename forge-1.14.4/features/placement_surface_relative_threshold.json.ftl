if(!(((long) world.getHeight(Heightmap.Type.${field$heightmap}, placePos.getX(), placePos.getZ()) + (long) ${field$min}) <= (long) placePos.getY() && (long) placePos.getY() <= ((long) world.getHeight(Heightmap.Type.${field$heightmap}, placePos.getX(), placePos.getZ()) + (long) ${field$max})))
  return false;
