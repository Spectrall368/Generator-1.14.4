private static Block getRandomBlock(String name) {
		Tag<Block> tag = BlockTags.makeWrapperTag(name);
		return tag.getAllElements().isEmpty() ? Blocks.AIR : tag.getRandomElement(new Random());
}