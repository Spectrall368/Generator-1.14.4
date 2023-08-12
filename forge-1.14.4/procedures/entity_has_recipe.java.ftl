<#include "mcelements.ftl">
(new Object() {
    public boolean hasRecipe(Entity _ent, IRecipe<?> recipe) {
		    if (entity.world instanceof ServerWorld) {
			    ServerWorld serverWorld = (ServerWorld) entity.world;
			    RecipeManager recipeManager = serverWorld.getRecipeManager();
			    IRecipe<?> recipe = recipeManager.getRecipe(${toResourceLocation(input$recipe)}).orElse(null);
          if (_ent instanceof ServerPlayerEntity)
              return ((ServerPlayerEntity)_ent).getRecipeBook().isUnlocked(recipe);
          else if (_ent.world.isRemote() && _ent instanceof ClientPlayerEntity)
              return ((ClientPlayerEntity)_ent).getRecipeBook().isUnlocked(recipe);
          return false;
      }
    }
}.hasRecipe(entity, recipe))
