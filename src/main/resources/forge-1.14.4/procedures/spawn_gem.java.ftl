<#include "mcitems.ftl">
if (!(world.getWorld().isRemote())) {
	ItemEntity entityToSpawn = new ItemEntity(world.getWorld(), ${input$x}, ${input$y}, ${input$z}, ${mappedMCItemToItemStackCode(input$block, 1)});
	entityToSpawn.setPickupDelay(${opt.toInt(input$pickUpDelay!10)});
	<#if (field$despawn!"TRUE") == "FALSE">
	entityToSpawn.setNoDespawn();
	</#if>
	world.addEntity(entityToSpawn);
}