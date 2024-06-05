<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote && world.getWorld().getServer() != null) {
	BlockPos _bpLootTblWorld = ${toBlockPos(input$x, input$y, input$z)};
	for (ItemStack itemstackiterator : world.getWorld().getServer().getLootTableManager().getValue(${toResourceLocation(input$location)})
			.getRandomItems(new LootContext.Builder((ServerWorld) world)
					.withParameter(LootParameters.BLOCK_STATE, world.getWorld().getBlockState(_bpLootTblWorld))
					.withNullableParameter(LootParameters.BLOCK_ENTITY, world.getWorld().getTileEntity(_bpLootTblWorld))
					.register(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->