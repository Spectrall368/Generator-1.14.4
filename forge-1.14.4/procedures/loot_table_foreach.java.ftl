<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote && world.getWorld().getServer() != null) {
	for (ItemStack itemstackiterator : world.getWorld().getServer().getLootTableManager().getValue(${toResourceLocation(input$location)})
			.getRandomItems(new LootContext.Builder((ServerWorld) world).register(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->