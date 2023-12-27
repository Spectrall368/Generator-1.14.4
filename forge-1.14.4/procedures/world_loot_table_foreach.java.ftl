<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote && world.getServer() != null) {
	BlockPos _bpLootTblWorld = ${toBlockPos(input$x, input$y, input$z)};

	for (ItemStack itemstackiterator : world.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) world)
					.withParameter(LootParameter.BLOCK_STATE, world.getBlockState(_bpLootTblWorld))
					.withNullableParameter(LootParameter.BLOCK_ENTITY, world.getTileEntity(_bpLootTblWorld))
					.build(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
