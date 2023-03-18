@SubscribeEvent public void onEntityTick(LivingEvent.LivingUpdateEvent event){
	Entity entity = event.getEntityLiving();
	World world = entity.world;
	double i = entity.PosX();
	double j = entity.PosY();
	double k = entity.PosZ();
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x", i);
	dependencies.put("y", j);
	dependencies.put("z", k);
	dependencies.put("world", world);
	dependencies.put("entity", entity);
	dependencies.put("event", event);
	this.executeProcedure(dependencies);
}
