<#include "mcelements.ftl">
if(world.getWorld() instanceof World)
  ${field$dimension.replace("CUSTOM:", "")}PortalBlock.portalSpawn(((World) world.getWorld()), ${toBlockPos(input$x,input$y,input$z)});
