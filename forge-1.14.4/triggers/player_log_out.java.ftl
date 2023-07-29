@Mod.EventBusSubscriber private static class GlobalTrigger {
	@SubscribeEvent public static void onPlayerLoggedOut(PlayerEvent.PlayerLoggedOutEvent event) {
		Entity entity = event.getPlayer();
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x",entity.posX);
		dependencies.put("y",entity.posY);
		dependencies.put("z",entity.posZ);
		dependencies.put("world",entity.world);
		dependencies.put("entity",entity);
		dependencies.put("event",event);
		executeProcedure(dependencies);
	}
}
