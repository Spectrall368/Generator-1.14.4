<#include "mcelements.ftl">
Block.spawnDrops(world.getBlockState(${toBlockPos(input$x,input$y,input$z)}), world.getWorld(), ${toBlockPos(input$x2,input$y2,input$z2)});
world.destroyBlock(${toBlockPos(input$x,input$y,input$z)}, false);
