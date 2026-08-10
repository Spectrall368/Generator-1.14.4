<@addTemplate file="utils/projectiles/projectile_potion.java.ftl"/>
private static Entity createPotionProjectile(World level, ItemStack contents, Entity shooter, Vec3d acceleration) {
	PotionEntity entityToSpawn = new PotionEntity(EntityType.POTION, level);
	entityToSpawn.setItem(contents);
	return initPotionProperties(entityToSpawn, shooter, acceleration);
}