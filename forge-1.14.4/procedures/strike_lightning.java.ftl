if(world instanceof ServerWorld) ((ServerWorld)world).addLightningBolt(
		new LightningBoltEntity(world.getWorld(),(int)${input$x},(int)${input$y},(int)${input$z},${(field$effectOnly!false)?lower_case}));
