if(world instanceof ServerWorld) {
	World projectileLevel = world.getWorld();
	Entity _entityToSpawn = ${input$projectile};
	_entityToSpawn.setPosition(${input$x}, ${input$y}, ${input$z});
	if (_entityToSpawn instanceof IProjectile)
	    ((IProjectile) _entityToSpawn).shoot(${input$dx}, ${input$dy}, ${input$dz}, ${opt.toFloat(input$speed)}, ${opt.toFloat(input$inaccuracy)});
	world.addEntity(_entityToSpawn);
}
