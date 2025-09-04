private static Item getRandomItem(ResourceLocation name) {
		Tag<Item> tag = ItemTags.getCollection().getOrCreate(name);
		return tag.getAllElements().isEmpty() ? Items.AIR : tag.getRandomElement(new Random());
}