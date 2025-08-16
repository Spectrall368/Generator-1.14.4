private static Item getRandomItem(String name) {
		Tag<Item> tag = ItemTags.makeWrapperTag(name);
		return tag.getAllElements().isEmpty() ? Items.AIR : tag.getRandomElement(new Random());
}