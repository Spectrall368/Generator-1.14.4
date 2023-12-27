<#include "mcelements.ftl">
<#-- @formatter:off -->
if (!world.isRemote && world.getServer() != null) {
	for (ItemStack itemstackiterator : world.getServer().getLootTables().get(${toResourceLocation(input$location)})
			.generate(new Loot.Builder((ServerWorld) world).create(LootParameterSets.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
