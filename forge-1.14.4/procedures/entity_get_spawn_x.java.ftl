((${input$entity} instanceof ServerPlayerEntity && !((ServerPlayerEntity) ${input$entity}).world.isRemote) ?
((((ServerPlayerEntity) ${input$entity}).getRespawnDimension() == ((ServerPlayerEntity) ${input$entity}).dimension.getId() && ObfuscationReflectionHelper.getPrivateValue(PlayerEntity.class, ((ServerPlayerEntity) ${input$entity}).spawnPos, "field_71077_c") != null) ?
ObfuscationReflectionHelper.getPrivateValue(PlayerEntity.class, ((ServerPlayerEntity) ${input$entity}).spawnPos, "field_71077_c").getX() : ((ServerPlayerEntity) ${input$entity}).world.getWorldInfo().getSpawnX()) : 0)
