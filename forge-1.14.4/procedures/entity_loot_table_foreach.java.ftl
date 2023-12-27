<#include "mcelements.ftl">
<#-- @formatter:off -->
if (${input$entity} instanceof LivingEntity && !((LivingEntity) ${input$entity}).world.isRemote && ((LivingEntity) ${input$entity}).getServer() != null) {
	DamageSource _ds = ((LivingEntity) ${input$entity}).getLastDamageSource();
	if (_ds == null) _ds = DamageSource.GENERIC;
	for (ItemStack itemstackiterator : ((LivingEntity) ${input$entity}).getServer().getLootTables().get(${toResourceLocation(input$location)})
			.generate(new LootContext.Builder((ServerWorld) ((LivingEntity) ${input$entity}).world)
					.withParameter(LootParameter.THIS_ENTITY, ((LivingEntity) ${input$entity}))
					.withNullableParameter(LootParameter.LAST_DAMAGE_PLAYER, ((LivingEntity) ${input$entity}).getRevengeTarget() instanceof PlayerEntity ? ((PlayerEntity) ((LivingEntity) ${input$entity}).getRevengeTarget()) : null)
					.withParameter(LootParameter.DAMAGE_SOURCE, _ds)
					.withNullableParameter(LootParameter.KILLER_ENTITY, _ds.getTrueSource())
					.withOptionalParameter(LootParameter.DIRECT_KILLER_ENTITY, _ds.getImmediateSource())
					.withParameter(LootParameter.BLOCK_STATE, ((LivingEntity) ${input$entity}).world.getBlockState(new BlockPos(((LivingEntity) ${input$entity}))))
					.withNullableParameter(LootParameter.BLOCK_ENTITY, ((LivingEntity) ${input$entity}).world.getTileEntity(new BlockPos(((LivingEntity) ${input$entity}))))
					.withParameter(LootParameter.TOOL, ((LivingEntity) ${input$entity}) instanceof PlayerEntity ? ((PlayerEntity) ((LivingEntity) ${input$entity})).inventory.getCurrentItem() : ((LivingEntity) ${input$entity}).getActiveItemStack())
					.withParameter(LootParameter.EXPLOSION_RADIUS, 0f)
					.withLuck(((LivingEntity) ${input$entity}) instanceof PlayerEntity ? ((PlayerEntity) ((LivingEntity) ${input$entity})).getLuck() : 0)
					.build(LootParameterSet.EMPTY))) {
		${statement$foreach}
	}
}
<#-- @formatter:on -->
