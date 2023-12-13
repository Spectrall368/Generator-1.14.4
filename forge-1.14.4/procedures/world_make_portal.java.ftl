<#include "mcelements.ftl">
if(world.getWorld() instanceof World)
  ${(field$dimension.toString().replace("CUSTOM:", ""))}Dimension.portal.portalSpawn(((World) world.getWorld()), ${toBlockPos(input$x,input$y,input$z)});
