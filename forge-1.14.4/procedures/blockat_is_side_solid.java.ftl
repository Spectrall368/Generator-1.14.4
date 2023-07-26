<#include "mcelements.ftl">
(Block.hasSolidSide(world.getBlockState(${toBlockPos(input$x,input$y,input$z)}), world, ${toBlockPos(input$x,input$y,input$z)}, ${input$direction}))
