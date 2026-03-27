if (${input$entity} instanceof LivingEntity) {
    LivingEntity _entity = (LivingEntity) ${input$entity};
	_entity.getAttribute(${generator.map(field$attribute, "attributes")}).getModifiers().forEach((_attribute) -> {
        if(_attribute.getName().equals(${'"' + modid + ':' + field$name + '"'})) _entity.getAttribute(${generator.map(field$attribute, "attributes")}).removeModifier(_attribute);
	});
}