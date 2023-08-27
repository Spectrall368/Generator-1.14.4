<#include "mcelements.ftl">
(new Object() {
	public Item getRandomItem(ResourceLocation name) {
		net.minecraft.tags.Tag<Item> _tag = ItemTags.getCollection().getOrCreate(name);
		return _tag.getAllElements().isEmpty() ? Items.AIR : _tag.getRandomElement(new Random());
}}.getRandomItem(${toResourceLocation(input$tag)}))
