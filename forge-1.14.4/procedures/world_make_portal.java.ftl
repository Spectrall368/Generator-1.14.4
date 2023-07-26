<#include "mcelements.ftl">
if(world instanceof World) ${(field$dimension.toString().replace("CUSTOM:", ""))}Dimension.portal.portalSpawn(world.getWorld(), ${toBlockPos(input$x,input$y,input$z)});
