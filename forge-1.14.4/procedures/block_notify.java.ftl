<#include "mcelements.ftl">
if(world instanceof World)
    ((World) world.getWorld()).notifyNeighborsOfStateChange(${toBlockPos(input$x,input$y,input$z)},
        ((World) world.getWorld()).getBlockState(${toBlockPos(input$x,input$y,input$z)}).getBlock());
