if (!(world.getHeight(Heightmap.Type.${field$heightmap}, pos.getX(), pos.getZ()) < ${field$max} && world.getHeight(Heightmap.Type.${field$heightmap}, pos.getX(), pos.getZ()) > ${field$min}))
  return false;
