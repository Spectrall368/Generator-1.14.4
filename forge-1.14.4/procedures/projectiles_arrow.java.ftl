<#assign projectile = generator.map(field$projectile, "projectiles", 1)>
<#assign hasShooter = (input$shooter != "null")>
<#assign isPiercing = (input$piercing != "/*@int*/0")>
new Object() {
	public Entity getArrow(World world<#if hasShooter>, Entity shooter</#if>, float damage, int knockback<#if isPiercing>, byte piercing</#if>) {
		AbstractArrowEntity entityToSpawn = new ${generator.map(field$projectile, "projectiles", 0)}(${projectile}, world.getWorld());
		<#if hasShooter>entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? ((LivingEntity) shooter) : null);</#if>
		entityToSpawn.setDamage(damage);
		entityToSpawn.setKnockbackStrength(knockback);
		<#if field$projectile?starts_with("CUSTOM:")>entityToSpawn.setSilent(true);</#if>
		<#if isPiercing>entityToSpawn.func_213872_b(piercing);</#if>
		<#if field$fire == "TRUE">entityToSpawn.setFire(100);</#if>
		<#if field$particles == "TRUE">entityToSpawn.setIsCritical(true);</#if>
		<#if field$pickup != "DISALLOWED">entityToSpawn.pickupStatus = AbstractArrowEntity.PickupStatus.${field$pickup};</#if>
		return entityToSpawn;
}}.getArrow(projectileLevel<#if hasShooter>, ${input$shooter}</#if>, ${opt.toFloat(input$damage)}, ${opt.toInt(input$knockback)}<#if isPiercing>, (byte) ${input$piercing}</#if>)
