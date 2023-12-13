<#include "mcelements.ftl">
/*@int*/(world.getWorld() instanceof World ? ((World) world.getWorld()).getRedstonePower(${toBlockPos(input$x,input$y,input$z)}, ${input$direction}):0)
