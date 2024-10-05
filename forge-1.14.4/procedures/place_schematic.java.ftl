<#include "mcelements.ftl">
if (world instanceof ServerWorld) {
	Template template = ((ServerWorld) world.getWorld()).getSaveHandler().getStructureTemplateManager()
		.getTemplateDefaulted(new ResourceLocation("${modid}", "${field$schematic}"));
	if (template != null) {
		template.addBlocksToWorld((ServerWorld) world.getWorld(),
			${toBlockPos(input$x,input$y,input$z)},
			new PlacementSettings()
				.setRotation(Rotation.<#if (field$rotation!'NONE') != "RANDOM">${field$rotation!'NONE'}<#else>func_222466_a(((ServerWorld) world.getWorld()).rand)</#if>)
				.setMirror(Mirror.<#if (field$mirror!'NONE') != "RANDOM">${field$mirror!'NONE'}<#else>values()[((ServerWorld) world.getWorld()).rand.nextInt(2)]</#if>)
				.setIgnoreEntities(false), 3);
	}
}
