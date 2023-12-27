<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isClientSide() && world.getServer() != null) {
	BlockPos _bp = ${toBlockPos(input$x, input$y, input$z)};

	for (ItemStack itemstackiterator : world.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.generate(new Loot.Builder((ServerWorld) world)
					.withParameter(LootParameter.BLOCK_STATE, world.getBlockState(_bp))
					.withOptionalParameter(LootParameter.BLOCK_ENTITY, world.getTileEntity(_bp))
					.create(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
