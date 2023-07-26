<#include "mcelements.ftl">
if(BoneMealItem.applyBonemeal(new ItemStack(Items.BONE_MEAL),world.getWorld(),${toBlockPos(input$x,input$y,input$z)})||
    BoneMealItem.growSeagrass(new ItemStack(Items.BONE_MEAL),world.getWorld(),${toBlockPos(input$x,input$y,input$z)},(Direction)null)){
    if(!world.getWorld().isRemote)
    	world.getWorld().playEvent(2005,${toBlockPos(input$x,input$y,input$z)},0);
}
