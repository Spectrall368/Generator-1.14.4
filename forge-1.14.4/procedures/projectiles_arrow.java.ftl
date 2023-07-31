<#assign projectile = generator.map(field$projectile, "projectiles", 1)>
<#assign hasShooter = (input$shooter != "null")>
<#assign isPiercing = (input$piercing != "/*@int*/0")>
new Object() {
	public Entity getArrow(World world<#if hasShooter>, Entity shooter</#if>, float damage, int knockback<#if isPiercing>, byte piercing</#if>) {
		AbstractArrowEntity _entityToSpawn = new ${generator.map(field$projectile, "projectiles", 0)}(${projectile}, world);
		<#if hasShooter>_entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? (LivingEntity) shooter : null);</#if>
		_entityToSpawn.setDamage(${input$damage});
		_entityToSpawn.setKnockbackStrength(${input$knockback});
		<#if field$projectile?starts_with("CUSTOM:")>_entityToSpawn.setSilent(true);</#if>
		<#if isPiercing>_entityToSpawn.setPierceLevel( (byte) ${input$piercing});</#if>
		<#if field$fire?lower_case == "true">_entityToSpawn.setFire(100);</#if>
		<#if field$particles?lower_case == "true">_entityToSpawn.setIsCritical(true);</#if>
		<#if field$pickup != "DISALLOWED">_entityToSpawn.pickupStatus = AbstractArrowEntity.PickupStatus.${field$pickup};</#if>
		return _entityToSpawn;
}}.getArrow(projectileLevel<#if hasShooter>, ${input$shooter}</#if>, ${opt.toFloat(input$damage)}, ${opt.toInt(input$knockback)}<#if isPiercing>, (byte) ${input$piercing}</#if>)
