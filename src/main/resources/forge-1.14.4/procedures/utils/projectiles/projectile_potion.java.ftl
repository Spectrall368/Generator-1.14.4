private static ThrowableEntity initPotionProperties(ThrowableEntity entityToSpawn, Entity shooter, Vec3d acceleration) {
    if(shooter != null) {
        ObfuscationReflectionHelper.setPrivateValue(ThrowableEntity.class, entityToSpawn, shooter, "field_70192_c");
        ObfuscationReflectionHelper.setPrivateValue(ThrowableEntity.class, entityToSpawn, shooter.getUniqueID(), "field_200218_h");
    }
	if (!Vec3d.ZERO.equals(acceleration)) {
		entityToSpawn.setMotion(acceleration);
		entityToSpawn.isAirBorne = true;
	}
	return entityToSpawn;
}