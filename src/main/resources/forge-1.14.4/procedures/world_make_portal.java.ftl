<#include "mcelements.ftl">
if(world instanceof World)
  ${field$dimension.replace("CUSTOM:", "")}PortalBlock.portalSpawn(world.getWorld(), ${toBlockPos(input$x,input$y,input$z)});