if(${input$entity} instanceof LivingEntity _entity && !_entity.world.isRemote)
	_entity.addPotionEffect(new EffectInstance(${generator.map(field$potion, "effects")},${opt.toInt(input$duration)},${opt.toInt(input$level)}));
