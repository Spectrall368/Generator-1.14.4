<#include "mcelements.ftl">
if (world instanceof World) {
    BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
    if (BoneMealItem.applyBonemeal(new ItemStack(Items.BONE_MEAL), world.getWorld() , _bp) || BoneMealItem.growSeagrass(new ItemStack(Items.BONE_MEAL), world.getWorld(), _bp, (Direction)null)) {
    if(!world.getWorld().isRemote)
    	world.getWorld().playEvent(2005, _bp, 0);
    }
}
