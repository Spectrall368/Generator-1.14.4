<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.getWorld().isRemote() && world.getWorld().getServer() != null) {
	for (ItemStack itemstackiterator : world.getWorld().getServer().getLootTableManager().getLootTableFromLocation(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) world.getWorld()).build(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->