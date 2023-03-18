@SubscribeEvent public void onBlockPlace(BlockEvent.EntityPlaceEvent event){
	Entity entity = event.getEntity();
	Map<String, Object> dependencies = new HashMap<>();
	dependencies.put("x",event.getPos().getX());
	dependencies.put("y",event.getPos().getY());
	dependencies.put("z",event.getPos().getZ());
	dependencies.put("px",entity.PosX());
	dependencies.put("py",entity.PosY());
	dependencies.put("pz",entity.PosZ());
	dependencies.put("world",event.getWorld().getWorld());
	dependencies.put("entity",entity);
	dependencies.put("event",event);
	this.executeProcedure(dependencies);
}
