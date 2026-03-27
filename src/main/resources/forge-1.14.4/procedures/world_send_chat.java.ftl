if (world instanceof ServerWorld) {
	((ServerWorld) world.getWorld()).getServer().getPlayerList().sendMessage(new StringTextComponent(${input$text})
		<#if (field$color!"#ffffff")?substring(1) != "ffffff">.applyTextStyle(_s -> _s.setColor(0x${(field$color!"#ffffff")?substring(1)}))</#if>
		<#if (field$bold!"false")?lower_case == "true">.applyTextStyle(ChatFormatting.BOLD)</#if>
		<#if (field$italic!"false")?lower_case == "true">.applyTextStyle(ChatFormatting.ITALIC)</#if>
		<#if (field$underlined!"false")?lower_case == "true">.applyTextStyle(ChatFormatting.UNDERLINE)</#if>);
}