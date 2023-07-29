@Mod.EventBusSubscriber private static class GlobalTrigger {
	@SubscribeEvent public static void onEntityAttacked(LivingAttackEvent event) {
		if (event!=null && event.getEntity()!=null) {
			Entity entity=event.getEntity();
			Entity sourceentity=event.getSource().getTrueSource();
			Entity immediatesourceentity=event.getSource().getImmediateSource();
			double i=entity.posX;
			double j=entity.posY;
			double k=entity.posZ;
			double amount = event.getAmount();
			World world=entity.world;
			Map<String, Object> dependencies = new HashMap<>();
			dependencies.put("x",i);
			dependencies.put("y",j);
			dependencies.put("z",k);
			dependencies.put("amount", amount);
			dependencies.put("world",world);
			dependencies.put("entity",entity);
			dependencies.put("sourceentity",sourceentity);
			dependencies.put("immediatesourceentity",immediatesourceentity);
			dependencies.put("event",event);
			executeProcedure(dependencies);
		}
	}
}
