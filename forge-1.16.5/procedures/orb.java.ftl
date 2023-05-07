  public ActionResult<ItemStack> onItemRightClick(World worldIn, PlayerEntity playerIn, Hand handIn) {
    Vector3d lookVec = playerIn.getLookVec();
    double x = lookVec.x;
    double y = lookVec.y;
    double z = lookVec.z;
    playerIn.setMotion(x * 2.5D, y, z * 2.5D);
    worldIn.addParticle((IParticleData)ParticleTypes.${generator.map(field$particle, "particles")}, playerIn.getPosX(), playerIn.getPosY() + 1.0D, playerIn.getPosZ(), ${input$xs}D, ${input$ys}D, ${input$zs}D);
    worldIn.addParticle((IParticleData)ParticleTypes.${generator.map(field$particle, "particles")}, playerIn.getPosX(), playerIn.getPosY() + 1.5D, playerIn.getPosZ(), ${input$xs}D, ${input$ys}D, ${input$zs}D);
    return new ActionResult(ActionResultType.PASS, playerIn.getHeldItem(handIn));
  }
