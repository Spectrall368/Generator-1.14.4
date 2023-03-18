@SubscribeEvent public void onPlayerXPChange(PlayerXpEvent.XpChange event) {
	if (event != null && event.getEntity() != null) {
		Entity entity = event.getEntity();
		double i = entity.PosX();
		double j = entity.PosY();
		double k = entity.PosZ();
		int amount = event.getAmount();
		World world = entity.world;
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x", i);
		dependencies.put("y", j);
		dependencies.put("z", k);
		dependencies.put("world", world);
		dependencies.put("entity", entity);
		dependencies.put("amount", amount);
		dependencies.put("event", event);
		this.executeProcedure(dependencies);
	}
}
