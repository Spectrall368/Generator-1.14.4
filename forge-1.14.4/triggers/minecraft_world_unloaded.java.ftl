@Mod.EventBusSubscriber private static class GlobalTrigger {
	@SubscribeEvent public static void onWorldUnload(WorldEvent.Unload event) {
		World world = event.getWorld().getWorld();
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("world",world);
		dependencies.put("event",event);
		executeProcedure(dependencies);
	}
}
