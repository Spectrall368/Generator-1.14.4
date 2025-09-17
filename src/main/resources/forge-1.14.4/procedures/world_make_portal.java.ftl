<#include "mcelements.ftl">
if(world instanceof World)
  ${JavaModName}Blocks.${field$dimension.replace("CUSTOM:", "")?upper_case}_PORTAL.portalSpawn(world.getWorld(), ${toBlockPos(input$x,input$y,input$z)});