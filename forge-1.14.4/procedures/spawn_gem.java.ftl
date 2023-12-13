<#include "mcitems.ftl">
if (world.getWorld() instanceof World && !((World) world.getWorld()).isRemote) {
	ItemEntity entityToSpawn = new ItemEntity(((World) world.getWorld()), ${input$x}, ${input$y}, ${input$z}, ${mappedMCItemToItemStackCode(input$block, 1)});
	entityToSpawn.setPickupDelay(${opt.toInt(input$pickUpDelay!10)});
	<#if (field$despawn!true)?lower_case == "false">
	entityToSpawn.setNoDespawn();
	</#if>
	((World) world.getWorld()).addEntity(entityToSpawn);
}
