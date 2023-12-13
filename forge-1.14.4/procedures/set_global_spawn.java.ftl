<#include "mcelements.ftl">
if(world.getWorld() instanceof World) ((World) world.getWorld()).setSpawnPoint(${toBlockPos(input$x,input$y,input$z)});
