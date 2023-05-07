Vec3d lookVec = playerIn.getLookVec();
double x = lookVec.xCoord;
double y = lookVec.yCoord;
double z = lookVec.zCoord;
playerIn.addVelocity(x * 2.5D, y, z * 2.5D);
worldIn.addParticle((IParticleData)ParticleTypes.${generator.map(field$particle, "particles")}, playerIn.posX, playerIn.posY + 1.0D, playerIn.posZ, ${input$xs}D, ${input$ys}D, ${input$zs}D);
worldIn.addParticle((IParticleData)ParticleTypes.${generator.map(field$particle, "particles")}, playerIn.posX, playerIn.posY + 1.5D, playerIn.posZ, ${input$xs}D, ${input$ys}D, ${input$zs}D);
