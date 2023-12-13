<#include "mcelements.ftl">
/*@int*/(world.getWorld() instanceof World ? ((World) world.getWorld()).getRedstonePowerFromNeighbors(${toBlockPos(input$x,input$y,input$z)}):0)
