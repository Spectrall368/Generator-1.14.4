<#include "mcitems.ftl">
{
    FallingBlockEntity blockToSpawn = new FallingBlockEntity(world.getWorld(), ${input$x}, ${input$y}, ${input$z}, ${mappedBlockToBlockStateCode(input$block)});
    blockToSpawn.fallTime = 1;
    world.addEntity(blockToSpawn);
}