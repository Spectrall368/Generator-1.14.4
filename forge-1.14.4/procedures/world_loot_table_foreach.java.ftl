<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote && world.getServer() != null) {
	BlockPos _bp = ${toBlockPos(input$x, input$y, input$z)};

	for (ItemStack itemstackiterator : world.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) world)
					.withParameter(LootParameter.BLOCK_STATE, world.getBlockState(_bp))
					.withNullableParameter(LootParameter.BLOCK_ENTITY, world.getTileEntity(_bp))
					.build(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
