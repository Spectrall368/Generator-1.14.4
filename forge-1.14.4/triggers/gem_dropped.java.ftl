@Mod.EventBusSubscriber private static class GlobalTrigger {
	@SubscribeEvent public static void onGemDropped(ItemTossEvent event) {
		PlayerEntity entity=event.getPlayer();
		double i = entity.posX;
		double j = entity.posY;
		double k = entity.posZ;
		World world=entity.world;
		ItemStack itemstack=event.getEntityItem().getItem();
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x",i);
		dependencies.put("y",j);
		dependencies.put("z",k);
		dependencies.put("world",world);
		dependencies.put("entity",entity);
		dependencies.put("itemstack",itemstack);
		dependencies.put("event",event);
		executeProcedure(dependencies);
	}
}
