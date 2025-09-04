if (world instanceof World && !world.getWorld().isRemote())
	world.getWorld().createExplosion(null, ${input$x}, ${input$y}, ${input$z}, ${opt.toFloat(input$power)}, Explosion.Mode.${field$mode?replace("BLOCK", "DESTROY")?replace("MOB", "DESTROY")?replace("TNT", "BREAK")});
