@Mod.EventBusSubscriber private static class GlobalTrigger {
	@SubscribeEvent public static void onBlockBreak(BlockEvent.BreakEvent event) {
		Entity entity = event.getPlayer();
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("xpAmount",event.getExpToDrop());
		dependencies.put("x",event.getPos().getX());
		dependencies.put("y",event.getPos().getY());
		dependencies.put("z",event.getPos().getZ());
		dependencies.put("px",entity.posX);
		dependencies.put("py",entity.posY);
		dependencies.put("pz",entity.pozZ);
		dependencies.put("world",event.getWorld().getWorld());
		dependencies.put("entity",entity);
		dependencies.put("blockstate",event.getState());
		dependencies.put("event",event);
		executeProcedure(dependencies);
	}
}
