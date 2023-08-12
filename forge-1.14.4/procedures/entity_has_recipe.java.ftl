<#include "mcelements.ftl">
(new Object() {
	public boolean hasRecipe(Entity _ent, IRecipe<?> recipe) {
		ServerPlayerEntity serverplayer = (ServerPlayerEntity) entity;
		ClientPlayerEntity clientplayer = (ClientPlayerEntity) entity;
        	if (_ent instanceof ServerPlayerEntity)
        		return ((ServerPlayerEntity)_ent).getRecipeBook().isUnlocked(serverplayer.server.getRecipeManager().getRecipe(recipe).orElse(null));
        	else if (_ent.world.isRemote() && _ent instanceof ClientPlayerEntity)
        		return ((ClientPlayerEntity)_ent).getRecipeBook().isUnlocked(clientplayer.server.getRecipeManager().getRecipe(recipe).orElse(null));
        	return false;
      	}	
}.hasRecipe(${input$entity}, ${toResourceLocation(input$recipe)}))
