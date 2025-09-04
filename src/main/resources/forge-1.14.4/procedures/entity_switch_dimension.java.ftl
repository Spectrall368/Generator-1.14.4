<#if field$dimension??><#--Here for legacy reasons as field$dimension does not exist in older workspaces-->
if (${input$entity} instanceof ServerPlayerEntity && !((ServerPlayerEntity) ${input$entity}).world.isRemote()) {
	DimensionType destinationType = ${generator.map(field$dimension, "dimensions")};

	if (((ServerPlayerEntity) ${input$entity}).dimension == destinationType) return;

	ServerWorld nextWorld = ((ServerPlayerEntity) ${input$entity}).getServer().getWorld(destinationType);
	if (nextWorld != null) {
		ObfuscationReflectionHelper.setPrivateValue(ServerPlayerEntity.class, ((ServerPlayerEntity) ${input$entity}), true, "field_184851_cj");
		((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SChangeGameStatePacket(4, 0));
		((ServerPlayerEntity) ${input$entity}).teleport(nextWorld, ((ServerPlayerEntity) ${input$entity}).posX, ((ServerPlayerEntity) ${input$entity}).posY, ((ServerPlayerEntity) ${input$entity}).posZ, ((ServerPlayerEntity) ${input$entity}).rotationYaw, ((ServerPlayerEntity) ${input$entity}).rotationPitch);
		((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SPlayerAbilitiesPacket(((ServerPlayerEntity) ${input$entity}).abilities));
		for(EffectInstance effectinstance : ((ServerPlayerEntity) ${input$entity}).getActivePotionEffects())
			((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SPlayEntityEffectPacket(((ServerPlayerEntity) ${input$entity}).getEntityId(), effectinstance));
		((ServerPlayerEntity) ${input$entity}).connection.sendPacket(new SPlaySoundEventPacket(1032, BlockPos.ZERO, 0, false));
	}
}
</#if>