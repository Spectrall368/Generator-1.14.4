<#include "mcelements.ftl">
ResourceLocation recipeLocation = ${toResourceLocation(input$recipe)};
if (${input$entity}.world instanceof ServerWorld) {
  ServerWorld serverWorld = (ServerWorld) ${input$entity}.world;
	RecipeManager recipeManager = serverWorld.getRecipeManager();
	IRecipe<?> recipe = recipeManager.getRecipe(recipeLocation).orElse(null);
  if (recipe != null && new Object() {
    public boolean hasRecipe(Entity _ent, IRecipe<?> recipe) {
    if (_ent instanceof ServerPlayerEntity)
      return ((ServerPlayerEntity) _ent).getRecipeBook().isUnlocked(recipe);
    else if (_ent.world.isRemote() && _ent instanceof ClientPlayerEntity)
      return ((ClientPlayerEntity) _ent).getRecipeBook().isUnlocked(recipe);
    return false;
    }
  }.hasRecipe(${input$entity}, recipe))
