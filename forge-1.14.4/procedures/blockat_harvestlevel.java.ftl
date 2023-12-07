<#include "mcelements.ftl">
(world.getBlockState(${toBlockPos(input$x,input$y,input$z)}).getBlock().getHarvestLevel(world.getBlockState(${toBlockPos(input$x,input$y,input$z)})))
