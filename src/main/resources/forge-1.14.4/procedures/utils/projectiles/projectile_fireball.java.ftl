private static DamagingProjectileEntity initProjectileProperties(DamagingProjectileEntity entityToSpawn, Entity shooter, Vec3d acceleration) {
	entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? ((LivingEntity) shooter) : null);
	if (!Vec3d.ZERO.equals(acceleration)) {
		entityToSpawn.setMotion(acceleration);
		entityToSpawn.isAirBorne = true;
	}
	entityToSpawn.accelerationX = acceleration.x;
	entityToSpawn.accelerationY = acceleration.y;
	entityToSpawn.accelerationZ = acceleration.z;

	return entityToSpawn;
}