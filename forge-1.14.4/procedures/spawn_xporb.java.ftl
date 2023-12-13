if(world.getWorld() instanceof World && !((World) world.getWorld()).isRemote)
	((World) world.getWorld()).addEntity(new ExperienceOrbEntity(((World) world.getWorld()), ${input$x}, ${input$y}, ${input$z}, ${opt.toInt(input$xpamount)}));
