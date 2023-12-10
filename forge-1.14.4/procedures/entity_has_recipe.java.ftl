<#include "mcelements.ftl">
(new Object() {
    public boolean hasRecipe(Entity _ent, ResourceLocation recipe) {
        if (_ent instanceof ServerPlayerEntity)
            return ((ServerPlayerEntity) _ent).getRecipeBook().isUnlocked(((ServerPlayerEntity) _ent).server.getRecipeManager().getRecipe(recipe).orElse(null));
        else if (_ent.world.isRemote && _ent instanceof ClientPlayerEntity)
            return ((ClientPlayerEntity) _ent).getRecipeBook().isUnlocked(((ClientPlayerEntity) _ent).world.getRecipeManager().getRecipe(recipe).orElse(null));
        return false;
    }
}.hasRecipe(${input$entity}, ${toResourceLocation(input$recipe)}))
