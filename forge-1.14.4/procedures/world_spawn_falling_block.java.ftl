<#include "mcitems.ftl">
if (world.getWorld() instanceof ServerWorld) {
    FallingBlockEntity blockToSpawn = new FallingBlockEntity((ServerWorld) world.getWorld(), ${input$x}, ${input$y}, ${input$z}, ${mappedBlockToBlockStateCode(input$block)});
    blockToSpawn.fallTime = 1;
    world.addEntity(blockToSpawn);
}
