@Mod.EventBusSubscriber private static class GlobalTrigger {
	@SubscribeEvent public static void onItemCrafted(PlayerEvent.ItemCraftedEvent event) {
		Entity entity = event.getPlayer();
		World world = entity.world;
		double i = entity.posX;
		double j = entity.posY;
		double k = entity.posZ;
		ItemStack itemStack = event.getCrafting();
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x",i);
		dependencies.put("y",j);
		dependencies.put("z",k);
		dependencies.put("world",world);
		dependencies.put("entity",entity);
		dependencies.put("itemstack",itemStack);
		dependencies.put("event",event);
		executeProcedure(dependencies);
	}
}
