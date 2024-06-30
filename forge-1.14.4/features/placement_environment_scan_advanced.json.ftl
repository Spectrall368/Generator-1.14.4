for(i = 0; i < ${field$maxSteps} && ${input$searchCondition}; i++) {
  placePos = placePos.<#if generator.map(field$direction, "directions") == "Direction.DOWN">down<#else>up</#if>();
  if(!(${input$condition}))
    return false;
}
