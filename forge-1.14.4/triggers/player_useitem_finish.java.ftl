@SubscribeEvent public void onUseItemStart(LivingEntityUseItemEvent.Finish event) {
	if (event != null && event.getEntity() != null) {
		Entity entity = event.getEntity();
		double i = entity.posX;
		double j = entity.posY;
		double k = entity.posZ;
		double duration = event.getDuration();
    	ItemStack itemstack = event.getItem();
		World world = entity.world;
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x", i);
		dependencies.put("y", j);
		dependencies.put("z", k);
		dependencies.put("itemstack", itemstack);
    	dependencies.put("duration", duration);
		dependencies.put("world", world);
		dependencies.put("entity", entity);
		dependencies.put("event", event);
		this.executeProcedure(dependencies);
	}
}
