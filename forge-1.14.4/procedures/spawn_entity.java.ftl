<#assign entity = generator.map(field$entity, "entities", 1)!"null">
<#if entity != "null">
if (world.getWorld() instanceof ServerWorld) {
	Entity entityToSpawn = new ${generator.map(field$entity, "entities", 0)}(${entity}, ((ServerWorld) world.getWorld()));
	entityToSpawn.setLocationAndAngles(${input$x}, ${input$y}, ${input$z}, world.getRandom().nextFloat() * 360F, 0);

	if (entityToSpawn instanceof MobEntity)
        ((MobEntity) entityToSpawn).onInitialSpawn(((ServerWorld) world.getWorld()), world.getDifficultyForLocation(new BlockPos(entityToSpawn)), SpawnReason.MOB_SUMMONED, (ILivingEntityData) null, null);

	world.addEntity(entityToSpawn);
}
</#if>
