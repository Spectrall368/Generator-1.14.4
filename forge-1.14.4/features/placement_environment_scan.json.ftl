for(i = 0; i < ${field$maxSteps}; i++) {
  pos = pos.<#if generator.map(field$direction, "directions") == "Direction.DOWN">down<#else>up</#if>();
  if(${input$condition})
    condition = true;
}
