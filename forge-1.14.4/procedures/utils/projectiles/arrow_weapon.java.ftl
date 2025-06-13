private static AbstractArrowEntity createArrowWeaponItemStack(AbstractArrowEntity entityToSpawn, int knockback, byte piercing) {
	if (knockback > 0)
		entityToSpawn.setKnockbackStrength(knockback);
	if (piercing > 0)
		entityToSpawn.func_213872_b(piercing);
	return entityToSpawn;
}