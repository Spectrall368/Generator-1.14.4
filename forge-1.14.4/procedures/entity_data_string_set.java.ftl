if (${input$entity} instanceof ${generator.map(field$customEntity, "entities")})
	((${generator.map(field$customEntity, "entities")}) ${input$entity}).getDataManager().set(${generator.map(field$customEntity, "entities")}.DATA_${field$accessor}, ${input$value});