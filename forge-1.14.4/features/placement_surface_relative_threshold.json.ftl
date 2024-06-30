if (!(world.getHeight(${field$heightmap}, pos.getX(), pos.getZ()) < ${field$max} && world.getHeight(${field$heightmap}, pos.getX(), pos.getZ()) > ${field$min}))
  return false;
