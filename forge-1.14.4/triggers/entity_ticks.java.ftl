@SubscribeEvent public void onEntityTick(LivingEvent.LivingUpdateEvent event){
	Entity entity = event.getEntity();
	World world = event.getWorld();
	double i = entity.posX;
	double j = entity.posY;
	double k = entity.posZ;
	java.util.HashMap<String, Object> dependencies = new java.util.HashMap<>();
	dependencies.put("x", i);
	dependencies.put("y", j);
	dependencies.put("z", k);
	dependencies.put("world", world);
	dependencies.put("entity", entity);
	dependencies.put("event", event);
	this.executeProcedure(dependencies);
}
