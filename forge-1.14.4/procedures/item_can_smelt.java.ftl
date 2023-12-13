<#include "mcitems.ftl">
(world.getWorld() instanceof World ? ((World) world.getWorld()).getRecipeManager().getRecipe(IRecipeType.SMELTING, new Inventory(${mappedMCItemToItemStackCode(input$item, 1)}), ((World) world.getWorld())).isPresent():false)
