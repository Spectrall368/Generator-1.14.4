<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.getWorld().isRemote && world.getWorld().getServer() != null) {
	BlockPos _bpLootTblWorld = ${toBlockPos(input$x, input$y, input$z)};
	for (ItemStack itemstackiterator : world.getWorld().getServer().getLootTableManager().getLootTableFromLocation(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) world)
					.withParameter(LootParameters.BLOCK_STATE, world.getWorld().getBlockState(_bpLootTblWorld))
					.withNullableParameter(LootParameters.BLOCK_ENTITY, world.getWorld().getTileEntity(_bpLootTblWorld))
					.build(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
