<#include "mcelements.ftl">
if (world instanceof ServerWorld) {
	Template template= ((ServerWorld) world.getWorld()).getSaveHandler().getStructureTemplateManager().getTemplateDefaulted(new ResourceLocation("${modid}" ,"${field$schematic}"));
	if(template!=null) {
		template.addBlocksToWorld(((ServerWorld) world.getWorld()),
				${toBlockPos(input$x,input$y,input$z)},
				new PlacementSettings()
						.setRotation(Rotation.${field$rotation!'NONE'})
						.setMirror(Mirror.${field$mirror!'NONE'})
						.setChunk(null)
						.setIgnoreEntities(false));
	}
}
