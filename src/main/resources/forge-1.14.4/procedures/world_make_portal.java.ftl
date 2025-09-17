<#include "mcelements.ftl">
if(world instanceof World)
  ${JavaModName}Blocks.${generator.getResourceLocationForModElement(field$dimension.replace("CUSTOM:", ""))?keep_after(":")?upper_case}_PORTAL.get().portalSpawn(world.getWorld(), ${toBlockPos(input$x,input$y,input$z)});