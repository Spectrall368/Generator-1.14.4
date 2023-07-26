<#include "mcelements.ftl">
if(world instanceof World)
    world.getWorld().notifyNeighborsOfStateChange(${toBlockPos(input$x,input$y,input$z)},
        world.getBlockState(${toBlockPos(input$x,input$y,input$z)}).getBlock());
