<#include "mcelements.ftl">
(new Object() {
	public Block getRandomBlock(ResourceLocation name) {
		net.minecraft.tags.Tag<Block> _tag = BlockTags.getCollection().getOrCreate(name);
		return _tag.getAllElements().isEmpty() ? Blocks.AIR : _tag.getRandomElement(new Random());
}}.getRandomBlock(${toResourceLocation(input$tag)}))
