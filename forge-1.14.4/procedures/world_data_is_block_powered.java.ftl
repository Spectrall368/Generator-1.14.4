<#include "mcelements.ftl">
(world.getWorld() instanceof World ? ((World) world.getWorld()).isBlockPowered(${toBlockPos(input$x,input$y,input$z)}):false)
