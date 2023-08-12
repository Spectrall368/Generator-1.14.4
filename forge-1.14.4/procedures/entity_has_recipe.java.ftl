<#include "mcelements.ftl">
(new Object() {
	public boolean hasRecipe(Entity _ent, ResourceLocation recipe) {
		ServerPlayerEntity serverplayer = (ServerPlayerEntity) entity;
        	if (_ent instanceof ServerPlayerEntity)
        		return ((ServerPlayerEntity)_ent).getRecipeBook().isUnlocked(serverplayer.server.getRecipeManager().getRecipe(recipe).orElse(null));
        	return false;
      	}	
}.hasRecipe(${input$entity}, ${toResourceLocation(input$recipe)}))
