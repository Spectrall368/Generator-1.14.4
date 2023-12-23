<#assign entity = generator.map(field$entity, "entities", 1)!"null">
<#if entity != "null">
if (world.getWorld() instanceof World && !world.getWorld().isRemote) {
	Entity entityToSpawn = new ${generator.map(field$entity, "entities", 0)}(${entity}, ((World) world.getWorld()));
	entityToSpawn.setLocationAndAngles(${input$x}, ${input$y}, ${input$z}, world.getRandom().nextFloat() * 360F, 0);

	if (entityToSpawn instanceof MobEntity)
        ((MobEntity) entityToSpawn).onInitialSpawn(((World) world.getWorld()), world.getDifficultyForLocation(new BlockPos(entityToSpawn)), SpawnReason.MOB_SUMMONED, null, null);

	world.addEntity(entityToSpawn);
}
</#if>
