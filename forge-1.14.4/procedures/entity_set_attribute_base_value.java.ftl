if (${input$entity} instanceof LivingEntity && ((LivingEntity) ${input$entity}).getAttributes().getAttributeInstance(${generator.map(field$attribute, "attributes")}) != null)
	((LivingEntity) ${input$entity}).getAttribute(${generator.map(field$attribute, "attributes")}).setBaseValue(${input$value});