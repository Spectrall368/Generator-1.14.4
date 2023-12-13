if (world.getWorld() instanceof World && !((World) world.getWorld()).isRemote)
	((World) world.getWorld()).createExplosion(null, ${input$x}, ${input$y}, ${input$z}, ${opt.toFloat(input$power)}, Explosion.Mode.${field$mode!"BREAK"});
