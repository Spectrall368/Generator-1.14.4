(${input$entity} instanceof LivingEntity && ((LivingEntity) ${input$entity}).world.getScoreboard().getPlayersTeam(((LivingEntity) ${input$entity}).getCachedUniqueIdString()) != null ?
	((LivingEntity) ${input$entity}).world.getScoreboard().getPlayersTeam(((LivingEntity) ${input$entity}) instanceof PlayerEntity ? ((PlayerEntity) ((LivingEntity) ${input$entity})).getGameProfile().getName() : ((LivingEntity) ${input$entity}).getCachedUniqueIdString()).getName() : "")