private static Block getRandomBlock(ResourceLocation name) {
		Tag<Block> tag = BlockTags.getCollection().getOrCreate(name);
		return tag.getAllElements().isEmpty() ? Blocks.AIR : tag.getRandomElement(new Random());
}