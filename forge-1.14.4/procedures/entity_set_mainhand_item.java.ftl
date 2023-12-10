<#include "mcitems.ftl">
if (${input$entity} instanceof LivingEntity) {
	ItemStack _setstack = ${mappedMCItemToItemStackCode(input$item, 1)};
	_setstack.setCount(${opt.toInt(input$amount)});
	((LivingEntity) ${input$entity}).setHeldItem(Hand.MAIN_HAND, _setstack);
	if (((LivingEntity) ${input$entity}) instanceof PlayerEntity) ((PlayerEntity) ((LivingEntity) ${input$entity})).inventory.markDirty();
}
