<#include "mcitems.ftl">
if (${input$entity} instanceof LivingEntity) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)};
	_setstack.setCount(${opt.toInt(input$amount)});
	((LivingEntity) ${input$entity}).setHeldItem(Hand.OFF_HAND, _setstack);
	if (${input$entity} instanceof PlayerEntity) ((PlayerEntity) ${input$entity}).inventory.markDirty();
}
