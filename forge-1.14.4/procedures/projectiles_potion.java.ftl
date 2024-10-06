<#assign hasShooter = (input$shooter != "null")>
<#assign hasAcceleration = (input$ax != "/*@int*/0") || (input$ay != "/*@int*/0") || (input$az != "/*@int*/0")>
new Object() {
	public Entity getPotion(World level<#if hasShooter>, Entity shooter</#if><#if hasAcceleration>, double ax, double ay, double az</#if>) {
		PotionEntity entityToSpawn = new PotionEntity(EntityType.POTION, level);
		entityToSpawn.setItem(PotionUtils.addPotionToItemStack(Items.${field$potionType}.getDefaultInstance(), ${generator.map(field$potion, "potions")}));
		<#if hasShooter>entityToSpawn.shootingEntity = (shooter instanceof LivingEntity ? ((LivingEntity) shooter) : null);</#if>
		<#if hasAcceleration>
		entityToSpawn.setMotion(new Vec3d(ax, ay, az));
		entityToSpawn.isAirBorne = true;
		</#if>
		return entityToSpawn;
	}
}.getPotion(projectileLevel<#if hasShooter>, ${input$shooter}</#if><#if hasAcceleration>, ${input$ax}, ${input$ay}, ${input$az}</#if>)
