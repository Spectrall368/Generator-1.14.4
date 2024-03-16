if(world.getWorld() instanceof ServerWorld) {
	World projectileLevel = (World) world.getWorld();
	Entity _entityToSpawn = ${input$projectile};
	_entityToSpawn.setPosition(${input$x}, ${input$y}, ${input$z});
	if (_entityToSpawn instanceof IProjectile)
	    ((IProjectile) _entityToSpawn).shoot(${input$dx}, ${input$dy}, ${input$dz}, ${opt.toFloat(input$speed)}, ${opt.toFloat(input$inaccuracy)});
	((ServerWorld) world.getWorld()).addEntity(_entityToSpawn);
}
