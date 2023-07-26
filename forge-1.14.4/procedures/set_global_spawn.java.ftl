<#include "mcelements.ftl">
if(world instanceof World) world.getWorld().setSpawnPoint(${toBlockPos(input$x,input$y,input$z)});
