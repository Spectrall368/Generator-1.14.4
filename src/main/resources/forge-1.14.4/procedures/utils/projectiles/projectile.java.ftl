private static DamagingProjectileEntity initProjectileProperties(DamagingProjectileEntity entityToSpawn, Entity shooter, Vec3d acceleration) {
	entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? ((LivingEntity) shooter) : null);
	if (!Vec3d.ZERO.equals(acceleration)) {
		entityToSpawn.setMotion(acceleration);
		entityToSpawn.isAirBorne = true;
	}
	return entityToSpawn;
}

private static ThrowableEntity initProjectileProperties(ThrowableEntity entityToSpawn, Entity shooter, Vec3d acceleration) {
	ObfuscationReflectionHelper.setPrivateValue(ThrowableEntity.class, entityToSpawn, shooter, "field_70192_c");
	ObfuscationReflectionHelper.setPrivateValue(ThrowableEntity.class, entityToSpawn, shooter.getUniqueID(), "field_200218_h");
	if (!Vec3d.ZERO.equals(acceleration)) {
		entityToSpawn.setMotion(acceleration);
		entityToSpawn.isAirBorne = true;
	}
	return entityToSpawn;
}