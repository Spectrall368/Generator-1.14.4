<#include "mcelements.ftl">
if (world.getWorld() instanceof World) {
    BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
    if (BoneMealItem.applyBonemeal(new ItemStack(Items.BONE_MEAL), ((World) world.getWorld()), _bp) || BoneMealItem.growSeagrass(new ItemStack(Items.BONE_MEAL), ((World) world.getWorld()), _bp, null)) {
    if(!((World) world.getWorld()).isRemote)
    	((World) world.getWorld()).playEvent(2005, _bp, 0);
    }
}
