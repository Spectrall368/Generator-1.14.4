if(${input$entity} instanceof LivingEntity)
	((LivingEntity)${input$entity}).addPotionEffect(new EffectInstance(${generator.map(field$potion, "effects")},(int) ${input$duration},(int) ${input$level}, ${input$ambient}, ${input$particles}));
