<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
 # 
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 # 
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 # 
 # Additional permission for code generator templates (*.ftl files)
 # 
 # As a special exception, you may create a larger work that contains part or 
 # all of the MCreator code generator templates (*.ftl files) and distribute 
 # that work under terms of your choice, so long as that work isn't itself a 
 # template for code generation. Alternatively, if you modify or redistribute 
 # the template itself, you may (at your option) remove this special exception, 
 # which will cause the template and the resulting code generator output files 
 # to be licensed under the GNU General Public License without this special 
 # exception.
-->

<#-- @formatter:off -->
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
<#include "../particles.java.ftl">
package ${package}.entity;

import net.minecraft.block.material.Material;
import net.minecraft.util.SoundEvent;

<#assign extendsClass = "Creature">

<#if data.aiBase != "(none)" >
	<#assign extendsClass = data.aiBase>
<#else>
	<#assign extendsClass = data.mobBehaviourType.replace("Mob", "Monster")>
</#if>

<#if data.breedable>
	<#assign extendsClass = "Animal">
</#if>

<#if (data.tameable && data.breedable)>
	<#assign extendsClass = "Tameable">
</#if>

<#if data.spawnThisMob>@Mod.EventBusSubscriber</#if>
public class ${name}Entity extends ${extendsClass}Entity <#if data.ranged>implements IRangedAttackMob</#if> {

	<#if data.spawnThisMob>
		for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
			<#if data.restrictionBiomes?has_content>
				boolean biomeCriteria = false;
				<#list data.restrictionBiomes as restrictionBiome>
					<#if restrictionBiome.canProperlyMap()>
					if (ForgeRegistries.BIOMES.getKey(biome).equals(new ResourceLocation("${restrictionBiome}")))
						biomeCriteria = true;
					</#if>
				</#list>
				if (!biomeCriteria)
					continue;
			</#if>

			biome.getSpawns(${generator.map(data.mobSpawningType, "mobspawntypes")}).add(new Biome.SpawnListEntry(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), ${data.spawningProbability},
							${data.minNumberOfMobsPerGroup}, ${data.maxNumberOfMobsPerGroup}));
		}
	</#if>

	<#if data.isBoss>
	private final ServerBossInfo bossInfo = new ServerBossInfo(this.getDisplayName(),
		BossInfo.Color.${data.bossBarColor}, BossInfo.Overlay.${data.bossBarType});
	</#if>

	public ${name}Entity(FMLPlayMessages.SpawnEntity packet, World world) {
    	this(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), world);
    }

	public ${name}Entity(EntityType<${name}Entity> type, World world) {
    	super(type, world);
		experienceValue = ${data.xpAmount};
		setNoAI(${(!data.hasAI)});

		<#if data.mobLabel?has_content >
        	setCustomName(new StringTextComponent("${data.mobLabel}"));
        	setCustomNameVisible(true);
        	</#if>

		<#if !data.doesDespawnWhenIdle>
			enablePersistence();
        	</#if>

	<#if !data.equipmentMainHand.isEmpty()>
        this.setItemStackToSlot(EquipmentSlotType.MAINHAND, ${mappedMCItemToItemStackCode(data.equipmentMainHand, 1)});
        </#if>
        <#if !data.equipmentOffHand.isEmpty()>
        this.setItemStackToSlot(EquipmentSlotType.OFFHAND, ${mappedMCItemToItemStackCode(data.equipmentOffHand, 1)});
        </#if>
        <#if !data.equipmentHelmet.isEmpty()>
        this.setItemStackToSlot(EquipmentSlotType.HEAD, ${mappedMCItemToItemStackCode(data.equipmentHelmet, 1)});
        </#if>
        <#if !data.equipmentBody.isEmpty()>
        this.setItemStackToSlot(EquipmentSlotType.CHEST, ${mappedMCItemToItemStackCode(data.equipmentBody, 1)});
        </#if>
        <#if !data.equipmentLeggings.isEmpty()>
        this.setItemStackToSlot(EquipmentSlotType.LEGS, ${mappedMCItemToItemStackCode(data.equipmentLeggings, 1)});
        </#if>
        <#if !data.equipmentBoots.isEmpty()>
        this.setItemStackToSlot(EquipmentSlotType.FEET, ${mappedMCItemToItemStackCode(data.equipmentBoots, 1)});
        </#if>

		<#if data.flyingMob>
		this.moveController = new FlyingMovementController(this);
		<#elseif data.waterMob>
		this.setPathPriority(PathNodeType.WATER, 0);
		this.moveController = new MovementController(this) {
			@Override public void tick() {
			    if (${name}Entity.this.isInWater())
                    ${name}Entity.this.setMotion(${name}Entity.this.getMotion().add(0, 0.005, 0));

				if (this.action == MovementController.Action.MOVE_TO && !${name}Entity.this.getNavigator().noPath()) {
					double dx = this.posX - ${name}Entity.this.posX;
					double dy = this.posY - ${name}Entity.this.posY;
					double dz = this.posZ - ${name}Entity.this.posZ;

					float f = (float) (MathHelper.atan2(dz, dx) * (double) (180 / Math.PI)) - 90;
					float f1 = (float) (this.speed * ${name}Entity.this.getAttribute(SharedMonsterAttributes.MOVEMENT_SPEED).getValue());

					${name}Entity.this.rotationYaw = this.limitAngle(${name}Entity.this.rotationYaw, f, 10);
					${name}Entity.this.renderYawOffset = ${name}Entity.this.rotationYaw;
					${name}Entity.this.rotationYawHead = ${name}Entity.this.rotationYaw;

					if (${name}Entity.this.isInWater()) {
						${name}Entity.this.setAIMoveSpeed((float) ${name}Entity.this.getAttribute(SharedMonsterAttributes.MOVEMENT_SPEED).getValue());

						float f2 = - (float) (MathHelper.atan2(dy, (float) Math.sqrt(dx * dx + dz * dz)) * (180 / Math.PI));
						f2 = MathHelper.clamp(MathHelper.wrapDegrees(f2), -85, 85);
						${name}Entity.this.rotationPitch = this.limitAngle(${name}Entity.this.rotationPitch, f2, 5);
						float f3 = MathHelper.cos(${name}Entity.this.rotationPitch * (float) (Math.PI / 180.0));

						${name}Entity.this.setMoveForward(f3 * f1);
						${name}Entity.this.setMoveVertical((float) (f1 * dy));
					} else {
						${name}Entity.this.setAIMoveSpeed(f1 * 0.05F);
					}
				} else {
					${name}Entity.this.setAIMoveSpeed(0);
					${name}Entity.this.setMoveVertical(0);
					${name}Entity.this.setMoveForward(0);
				}
			}
		};
		</#if>
	}

	@Override public IPacket<?> createSpawnPacket() {
		return NetworkHooks.getEntitySpawningPacket(this);
	}

	<#if data.flyingMob>
	@Override protected PathNavigator createNavigator(World world) {
		return new FlyingPathNavigator(this, world);
	}
	<#elseif data.waterMob>
	@Override protected PathNavigator createNavigator(World world) {
		return new SwimmerPathNavigator(this, world);
	}
	</#if>

	<#if data.hasAI>
	@Override protected void registerGoals() {
		super.registerGoals();

		<#if aicode??>
            ${aicode}
        </#if>

        <#if data.ranged>
            this.goalSelector.addGoal(1, new RangedAttackGoal(this, 1.25, 20, 10) {
				@Override public boolean shouldContinueExecuting() {
					return this.shouldExecute();
				}
			});
        </#if>
	}
	</#if>

	@Override public CreatureAttribute getCreatureAttribute() {
		return CreatureAttribute.${data.mobCreatureType};
	}

	<#if !data.doesDespawnWhenIdle>
	@Override public boolean canDespawn(double distanceToClosestPlayer) {
		return false;
	}
    	</#if>

	<#if data.mobModelName == "Biped">
	@Override public double getYOffset() {
		return -0.35D;
	}
	<#elseif data.mobModelName == "Silverfish">
	@Override public double getYOffset() {
		return 0.1D;
	}
	</#if>

	<#if data.mountedYOffset != 0>
	@Override public double getMountedYOffset() {
		return super.getMountedYOffset() + ${data.mountedYOffset};
	}
	</#if>

	<#if !data.mobDrop.isEmpty()>
    	protected void dropSpecialItems(DamageSource source, int looting, boolean recentlyHitIn) {
        	super.dropSpecialItems(source, looting, recentlyHitIn);
       		this.entityDropItem(${mappedMCItemToItemStackCode(data.mobDrop, 1)});
   	}
	</#if>

   	<#if data.livingSound.getMappedValue()?has_content>
	@Override public SoundEvent getAmbientSound() {
		return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.livingSound}"));
	}
	</#if>

   	<#if data.stepSound?has_content && data.stepSound.getMappedValue()?has_content>
	@Override public void playStepSound(BlockPos pos, BlockState blockIn) {
		this.playSound(ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.stepSound}")), 0.15f, 1);
	}
	</#if>

	@Override public SoundEvent getHurtSound(DamageSource ds) {
		return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.hurtSound}"));
	}

	@Override public SoundEvent getDeathSound() {
		return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.deathSound}"));
	}

	<#if hasProcedure(data.onStruckByLightning)>
	@Override public void onStruckByLightning(LightningBoltEntity lightningBolt) {
		super.onStruckByLightning(lightningBolt);
		<@procedureCode data.onStruckByLightning, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"world": "this.world"
		}/>
	}
    </#if>

	<#if hasProcedure(data.whenMobFalls) || data.flyingMob>
	@Override public boolean fall(float l, float d) {
		<#if hasProcedure(data.whenMobFalls)>
			<@procedureCode data.whenMobFalls, {
				"x": "this.posX",
				"y": "this.posY",
				"z": "this.posZ",
				"entity": "this",
				"world": "this.world"
			}/>
		</#if>

		<#if data.flyingMob >
			return false;
		<#else>
			return super.causeFallDamage(l, d);
		</#if>
	}
    </#if>

	<#if hasProcedure(data.whenMobIsHurt) || data.immuneToArrows || data.immuneToFallDamage
		|| data.immuneToCactus || data.immuneToDrowning || data.immuneToLightning || data.immuneToPotions
		|| data.immuneToPlayer || data.immuneToExplosion || data.immuneToTrident || data.immuneToAnvil
		|| data.immuneToDragonBreath || data.immuneToWither>
	@Override public boolean attackEntityFrom(DamageSource source, float amount) {
		<#if hasProcedure(data.whenMobIsHurt)>
			<@procedureCode data.whenMobIsHurt, {
				"x": "this.posX",
				"y": "this.posY",
				"z": "this.posZ",
				"entity": "this",
				"world": "this.world",
				"sourceentity": "source.getTrueSource()"
			}/>
		</#if>
		<#if data.immuneToArrows>
			if (source.getImmediateSource() instanceof AbstractArrowEntity)
				return false;
		</#if>
		<#if data.immuneToPlayer>
			if (source.getImmediateSource() instanceof PlayerEntity)
				return false;
		</#if>
		<#if data.immuneToPotions>
			if (source.getImmediateSource() instanceof PotionEntity || source.getImmediateSource() instanceof AreaEffectCloudEntity)
				return false;
		</#if>
		<#if data.immuneToFallDamage>
			if (source == DamageSource.FALL)
				return false;
		</#if>
		<#if data.immuneToCactus>
			if (source == DamageSource.CACTUS)
				return false;
		</#if>
		<#if data.immuneToDrowning>
			if (source == DamageSource.DROWN)
				return false;
		</#if>
		<#if data.immuneToLightning>
			if (source == DamageSource.LIGHTNING_BOLT)
				return false;
		</#if>
		<#if data.immuneToExplosion>
			if (source.isExplosion())
				return false;
		</#if>
		<#if data.immuneToTrident>
			if (source.getDamageType().equals("trident"))
				return false;
		</#if>
		<#if data.immuneToAnvil>
			if (source == DamageSource.ANVIL)
				return false;
		</#if>
		<#if data.immuneToDragonBreath>
			if (source == DamageSource.DRAGON_BREATH)
				return false;
		</#if>
		<#if data.immuneToWither>
			if (source == DamageSource.WITHER)
				return false;
			if (source.getDamageType().equals("witherSkull"))
				return false;
		</#if>
		return super.attackEntityFrom(source, amount);
	}
    </#if>

	<#if hasProcedure(data.whenMobDies)>
	@Override public void onDeath(DamageSource source) {
		super.onDeath(source);
		<@procedureCode data.whenMobDies, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"sourceentity": "source.getTrueSource()",
			"entity": "this",
			"world": "this.world"
		}/>
	}
    </#if>

	<#if hasProcedure(data.onInitialSpawn)>
	@Override public ILivingEntityData onInitialSpawn(IWorld world, DifficultyInstance difficulty, SpawnReason reason, ILivingEntityData livingdata, CompoundNBT tag) {
		ILivingEntityData retval = super.onInitialSpawn(world, difficulty, reason, livingdata, tag);
		<@procedureCode data.onInitialSpawn, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"world": "world",
			"entity": "this"
		}/>
		return retval;
	}
    </#if>

	<#if data.guiBoundTo?has_content && data.guiBoundTo != "<NONE>">
	private final ItemStackHandler inventory = new ItemStackHandler(${data.inventorySize}) {
		@Override public int getSlotLimit(int slot) {
			return ${data.inventoryStackSize};
		}
	};

	private final CombinedInvWrapper combined = new CombinedInvWrapper(inventory, new EntityHandsInvWrapper(this), new EntityArmorInvWrapper(this));

	@Override public <T> LazyOptional<T> getCapability(@Nonnull Capability<T> capability, @Nullable Direction side) {
		if (this.isAlive() && capability == CapabilityItemHandler.ITEM_HANDLER_CAPABILITY && side == null)
			return LazyOptional.of(() -> combined).cast();

		return super.getCapability(capability, side);
	}

   	@Override protected void dropInventory() {
		super.dropInventory();
		for(int i = 0; i < inventory.getSlots(); ++i) {
			ItemStack itemstack = inventory.getStackInSlot(i);
			if (!itemstack.isEmpty() && !EnchantmentHelper.hasVanishingCurse(itemstack)) {
				this.entityDropItem(itemstack);
			}
		}
	}

	@Override public void writeAdditional(CompoundNBT compound) {
    		super.writeAdditional(compound);
		compound.put("InventoryCustom", inventory.serializeNBT());
	}

	@Override public void readAdditional(CompoundNBT compound) {
    		super.readAdditional(compound);
		INBT inventoryCustom = compound.get("InventoryCustom");
		if(inventoryCustom instanceof CompoundNBT)
			inventory.deserializeNBT((CompoundNBT) inventoryCustom);
    }
    </#if>

	<#if hasProcedure(data.onRightClickedOn) || data.ridable || (data.tameable && data.breedable) || (data.guiBoundTo?has_content && data.guiBoundTo != "<NONE>")>
	@Override public processInteract(PlayerEntity sourceentity, Hand hand) {
		ItemStack itemstack = sourceentity.getHeldItem(hand);
		ActionResultType retval = ActionResultType.func_233537_a_(this.world.isRemote);

		<#if data.guiBoundTo?has_content && data.guiBoundTo != "<NONE>">
			<#if data.ridable>
				if (sourceentity.isSneaking()) {
			</#if>
				if(sourceentity instanceof ServerPlayerEntity) {
					NetworkHooks.openGui((ServerPlayerEntity) sourceentity, new INamedContainerProvider() {

						@Override public ITextComponent getDisplayName() {
							return new TextComponent("${data.mobName}");
						}

						@Override public Container createMenu(int id, PlayerInventory inventory, PlayerEntity player) {
							PacketBuffer packetBuffer = new PacketBuffer(Unpooled.buffer());
							packetBuffer.writeBlockPos(sourceentity.blockPosition());
							packetBuffer.writeByte(0);
							packetBuffer.writeVarInt(${name}Entity.this.getEntityId());
							return new ${data.guiBoundTo}Gui.GuiContainerMod(id, inventory, packetBuffer);
						}

					}, buf -> {
						buf.writeBlockPos(sourceentity.blockPosition());
						buf.writeByte(0);
						buf.writeVarInt(this.getEntityId());
					});
				}
			<#if data.ridable>
					return ActionResultType.func_233537_a_(this.world.isRemote);
				}
			</#if>
		</#if>

		<#if (data.tameable && data.breedable)>
			Item item = itemstack.getItem();
			if (itemstack.getItem() instanceof SpawnEggItem) {
				retval = super.processInteract(sourceentity, hand);
			} else if (this.world.isRemote) {
				retval = (this.isTamed() && this.isOwner(sourceentity) || this.isBreedingItem(itemstack))
						? ActionResultType.func_233537_a_(this.world.isRemote) : ActionResultType.PASS;
			} else {
				if (this.isTamed()) {
					if (this.isOwner(sourceentity)) {
						if (item.isFood() && this.isBreedingItem(itemstack) && this.getHealth() < this.getMaxHealth()) {
							this.consumeItemFromStack(sourceentity, itemstack);
							this.heal((float)item.getFood().getHealing());
							retval = ActionResultType.func_233537_a_(this.world.isRemote);
						} else if (this.isBreedingItem(itemstack) && this.getHealth() < this.getMaxHealth()) {
							this.consumeItemFromStack(sourceentity, itemstack);
							this.heal(4);
							retval = ActionResultType.func_233537_a_(this.world.isRemote);
						} else {
							retval = super.processInteract(sourceentity, hand);
						}
					}
				} else if (this.isBreedingItem(itemstack)) {
					this.consumeItemFromStack(sourceentity, itemstack);
					if (this.rand.nextInt(3) == 0 && !net.minecraftforge.event.ForgeEventFactory.onAnimalTame(this, sourceentity)) {
						this.setTamedBy(sourceentity);
						this.world.setEntityState(this, (byte) 7);
					} else {
						this.world.setEntityState(this, (byte) 6);
					}

					this.enablePersistence();
					retval = ActionResultType.func_233537_a_(this.world.isRemote);
				} else {
					retval = super.processInteract(sourceentity, hand);
					if (retval == ActionResultType.SUCCESS)
						this.enablePersistence();
				}
			}
		<#else>
			super.processInteract(sourceentity, hand);
		</#if>

		<#if data.ridable>
		sourceentity.startRiding(this);
	    </#if>

		<#if hasProcedure(data.onRightClickedOn)>
			double x = this.posX;
			double y = this.posY;
			double z = this.posZ;
			Entity entity = this;
			World world = this.world;
			<#if hasReturnValueOf(data.onRightClickedOn, "actionresulttype")>
				return <@procedureOBJToInteractionResultCode data.onRightClickedOn/>;
			<#else>
				<@procedureOBJToCode data.onRightClickedOn/>
				return retval;
			</#if>
		<#else>
			return retval;
		</#if>
	}
    </#if>

	<#if hasProcedure(data.whenThisMobKillsAnother)>
	@Override public void onKillEntity(LivingEntity entity) {
		super.onKillEntity(entity);
		<@procedureCode data.whenThisMobKillsAnother, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "entity",
			"sourceentity": "this",
			"world": "this.world"
		}/>
	}
    </#if>

	<#if hasProcedure(data.onMobTickUpdate)>
	@Override public void baseTick() {
		super.baseTick();
		<@procedureCode data.onMobTickUpdate, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"world": "this.world"
		}/>
	}
    </#if>

	<#if hasProcedure(data.onPlayerCollidesWith)>
	@Override public void onCollideWithPlayer(PlayerEntity sourceentity) {
		super.onCollideWithPlayer(sourceentity);
		<@procedureCode data.onPlayerCollidesWith, {
			"x": "this.posX",
			"y": "this.posY",
			"z": "this.posZ",
			"entity": "this",
			"sourceentity": "sourceentity",
			"world": "this.world"
		}/>
	}
    </#if>

    <#if data.ranged>
	    @Override public void attackEntityWithRangedAttack(LivingEntity target, float flval) {
			<#if data.rangedItemType == "Default item">
				<#if !data.rangedAttackItem.isEmpty()>
				${name}EntityProjectile entityarrow = new ${name}EntityProjectile(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}_PROJECTILE.get(), this, this.world);
				<#else>
				ArrowEntity entityarrow = new ArrowEntity(this.world, this);
				</#if>
				double d0 = target.posY + target.getEyeHeight() - 1.1;
				double d1 = target.posX - this.posX;
				double d3 = target.posZ - this.posZ;
				entityarrow.shoot(d1, d0 - entityarrow.posY + MathHelper.sqrt(d1 * d1 + d3 * d3) * 0.2F, d3, 1.6F, 12.0F);
				world.addEntity(entityarrow);
			<#else>
				${data.rangedItemType}Entity.shoot(this, target);
			</#if>
		}
    </#if>

	<#if data.breedable>
        @Override public AgeableEntity createChild(AgeableEntity ageable) {
			${name}Entity retval = ${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get().create(this.world);
			retval.onInitialSpawn(this.world, this.world.getDifficultyForLocation(retval.blockPosition()), SpawnReason.BREEDING, null, null);
			return retval;
		}

		@Override public boolean isBreedingItem(ItemStack stack) {
			List<ItemStack> breedingItem = new ArrayList<>();
			<#list data.breedTriggerItems as compatibleEnchantment>
			breedingItem.add(${mappedMCItemToItem(breedTriggerItem)});
			</#list>
			return breedingItem.contains(stack.getItem());
		}
    </#if>

	<#if data.waterMob>
	@Override public boolean canBreatheUnderwater() {
    		return true;
    	}

	@Override public boolean isNotColliding(IWorldReader world) {
		return world.checkNoEntityCollision(this);
	}

    @Override public boolean isPushedByWater() {
		return false;
    }
	</#if>

	<#if data.disableCollisions>
	@Override public boolean canBePushed() {
		return false;
	}

   	@Override protected void collideWithEntity(Entity entityIn) {}

   	@Override protected void collideWithNearbyEntities() {}
	</#if>

	<#if data.isBoss>
	@Override public boolean isNonBoss() {
		return false;
	}

	@Override public void addTrackingPlayer(ServerPlayerEntity player) {
		super.addTrackingPlayer(player);
		this.bossInfo.addPlayer(player);
	}

	@Override public void removeTrackingPlayer(ServerPlayerEntity player) {
		super.removeTrackingPlayer(player);
		this.bossInfo.removePlayer(player);
	}

	@Override public void updateAITasks() {
		super.updateAITasks();
		this.bossInfo.setPercent(this.getHealth() / this.getMaxHealth());
	}
	</#if>

    <#if data.ridable && (data.canControlForward || data.canControlStrafe)>
        @Override public void travel(Vec3d dir) {
        	<#if data.canControlForward || data.canControlStrafe>
			Entity entity = this.getPassengers().isEmpty() ? null : (Entity) this.getPassengers().get(0);
			if (this.isBeingRidden()) {
				this.rotationYaw = entity.rotationYaw;
				this.prevRotationYaw = this.rotationYaw;
				this.rotationPitch = entity.rotationPitch * 0.5F;
				this.setRotation(this.rotationYaw, this.rotationPitch);
				this.jumpMovementFactor = this.getAIMoveSpeed() * 0.15F;
				this.renderYawOffset = entity.rotationYaw;
				this.rotationYawHead = entity.rotationYaw;
				this.stepHeight = 1.0F;

				if (entity instanceof LivingEntity) {
					this.setAIMoveSpeed((float) this.getAttribute(SharedMonsterAttributes.MOVEMENT_SPEED));

					<#if data.canControlForward>
						float forward = ((LivingEntity) entity).moveForward;
					<#else>
						float forward = 0;
					</#if>

					<#if data.canControlStrafe>
						float strafe = ((LivingEntity) entity).moveStrafing;
					<#else>
						float strafe = 0;
					</#if>

					super.travel(new Vec3d(strafe, 0, forward));
				}

				this.prevLimbSwingAmount = this.limbSwingAmount;
				double d1 = this.posX - this.prevPosX;
				double d0 = this.posZ - this.prevPosZ;
				float f1 = (float) MathHelper.sqrt(d1 * d1 + d0 * d0) * 4;
				if (f1 > 1.0F) f1 = 1.0F;
				this.limbSwingAmount += (f1 - this.limbSwingAmount) * 0.4F;
				this.limbSwing += this.limbSwingAmount;
				return;
			}
			this.stepHeight = 0.5F;
			this.jumpMovementFactor = 0.02F;
			</#if>

			super.travel(dir);
		}
    </#if>

	<#if data.flyingMob>
	@Override protected void updateFallState(double y, boolean onGroundIn, BlockState state, BlockPos pos) {
   	}

   	@Override public void setNoGravity(boolean ignored) {
		super.setNoGravity(true);
	}
    </#if>

    <#if data.spawnParticles || data.flyingMob>
    public void livingTick() {
		super.livingTick();

		<#if data.flyingMob>
		this.setNoGravity(true);
		</#if>

		<#if data.spawnParticles>
		double x = this.posX;
		double y = this.posY;
		double z = this.posZ;
		Entity entity = this;
		World world = this.world;
		<#if hasProcedure(data.particleCondition)>
			if(<@procedureOBJToConditionCode data.particleCondition/>)
		</#if>
        <@particles data.particleSpawningShape data.particleToSpawn data.particleSpawningRadious data.particleAmount/>
		</#if>
	}
    </#if>

	public static void init() {
		FMLJavaModLoadingContext.get().getModEventBus().register(new ${name}Renderer(Minecraft.getInstance().getRenderManager()));

		<#if data.spawnThisMob>
			<#if data.mobSpawningType == "creature">
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(),
					EntitySpawnPlacementRegistry.PlacementType.ON_GROUND, Heightmap.Type.MOTION_BLOCKING_NO_LEAVES,
				<#if hasProcedure(data.spawningCondition)>
					(entityType, world, reason, pos, random) -> {
						int x = pos.getX();
						int y = pos.getY();
						int z = pos.getZ();
						return <@procedureOBJToConditionCode data.spawningCondition/>;
					}
				<#else>
					(entityType, world, reason, pos, random) ->
							(world.getBlockState(pos.below()).getMaterial() == Material.GRASS && world.getLightSubtracted(pos, 0) > 8)
				</#if>
			);
			<#elseif data.mobSpawningType == "ambient" || data.mobSpawningType == "misc">
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(),
					EntitySpawnPlacementRegistry.PlacementType.NO_RESTRICTIONS, Heightmap.Type.MOTION_BLOCKING_NO_LEAVES,
					<#if hasProcedure(data.spawningCondition)>
					(entityType, world, reason, pos, random) -> {
						int x = pos.getX();
						int y = pos.getY();
						int z = pos.getZ();
						return <@procedureOBJToConditionCode data.spawningCondition/>;
					}
					<#else>
					MobEntity::func_223315_a
					</#if>
			);
			<#elseif data.mobSpawningType == "waterCreature" || data.mobSpawningType == "waterAmbient">
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(),
					EntitySpawnPlacementRegistry.PlacementType.IN_WATER, Heightmap.Type.MOTION_BLOCKING_NO_LEAVES,
					<#if hasProcedure(data.spawningCondition)>
					(entityType, world, reason, pos, random) -> {
						int x = pos.getX();
						int y = pos.getY();
						int z = pos.getZ();
						return <@procedureOBJToConditionCode data.spawningCondition/>;
					}
					<#else>
					(entityType, world, reason, pos, random) ->
							(world.getBlockState(pos).is(Blocks.WATER) && world.getBlockState(pos.above()).is(Blocks.WATER))
					</#if>
			);
			<#elseif data.mobSpawningType == "undergroundWaterCreature">
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(),
					EntitySpawnPlacementRegistry.PlacementType.IN_WATER, Heightmap.Type.MOTION_BLOCKING_NO_LEAVES,
					<#if hasProcedure(data.spawningCondition)>
					(entityType, world, reason, pos, random) -> {
						int x = pos.getX();
						int y = pos.getY();
						int z = pos.getZ();
						return <@procedureOBJToConditionCode data.spawningCondition/>;
					}
					<#else>
					(entityType, world, reason, pos, random) -> {
					    return world.getFluidState(pos.below()).is(FluidTags.WATER) && world.getBlockState(pos.above()).is(Blocks.WATER) && pos.posY >= (world.getSeaLevel() - 13) && pos.posY <= world.getSeaLevel();
                    }
					</#if>
			);
			<#else>
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(),
					EntitySpawnPlacementRegistry.PlacementType.ON_GROUND, Heightmap.Type.MOTION_BLOCKING_NO_LEAVES,
					<#if hasProcedure(data.spawningCondition)>
					(entityType, world, reason, pos, random) -> {
						int x = pos.getX();
						int y = pos.getY();
						int z = pos.getZ();
						return <@procedureOBJToConditionCode data.spawningCondition/>;
					}
					<#else>
						(entityType, world, reason, pos, random) ->
								(world.getDifficulty() != Difficulty.PEACEFUL && MonsterEntity.func_223323_a(world, pos, random)
										&& MobEntity.func_223315_a(entityType, world, reason, pos, random))
					</#if>
			);
			</#if>
		</#if>

		<#if data.spawnInDungeons>
			DungeonHooks.addDungeonMob(${JavaModName}Entities.${data.getModElement().getRegistryNameUpper()}.get(), 180);
		</#if>
	}

	@Override protected void registerAttributes() {
		super.registerAttributes();

		if (this.getAttribute(SharedMonsterAttributes.MOVEMENT_SPEED) != null)
			this.getAttribute(SharedMonsterAttributes.MOVEMENT_SPEED).setBaseValue(${data.movementSpeed});

		if (this.getAttribute(SharedMonsterAttributes.MAX_HEALTH) != null)
			this.getAttribute(SharedMonsterAttributes.MAX_HEALTH).setBaseValue(${data.health});

		if (this.getAttribute(SharedMonsterAttributes.ARMOR) != null)
			this.getAttribute(SharedMonsterAttributes.ARMOR).setBaseValue(${data.armorBaseValue});

		if (this.getAttribute(SharedMonsterAttributes.ATTACK_DAMAGE) == null)
			this.getAttributes().registerAttribute(SharedMonsterAttributes.ATTACK_DAMAGE);
			this.getAttribute(SharedMonsterAttributes.ATTACK_DAMAGE).setBaseValue(${data.attackStrength});

		if (this.getAttribute(SharedMonsterAttributes.FOLLOW_RANGE) != null)
			this.getAttribute(SharedMonsterAttributes.FOLLOW_RANGE).setBaseValue(${data.followRange});

		<#if (data.knockbackResistance > 0)>
		if (this.getAttribute(SharedMonsterAttributes.KNOCKBACK_RESISTANCE) == null)
			this.getAttributes().registerAttribute(SharedMonsterAttributes.KNOCKBACK_RESISTANCE);
			this.getAttribute(SharedMonsterAttributes.KNOCKBACK_RESISTANCE).setBaseValue(${data.knockbackResistance}D);
		</#if>

		<#if (data.attackKnockback > 0)>
		if (this.getAttribute(SharedMonsterAttributes.ATTACK_KNOCKBACK) == null)
			this.getAttributes().registerAttribute(SharedMonsterAttributes.ATTACK_KNOCKBACK);
			this.getAttribute(SharedMonsterAttributes.ATTACK_KNOCKBACK).setBaseValue(${data.attackKnockback}D);
		</#if>

		<#if data.flyingMob>
		if (this.getAttribute(SharedMonsterAttributes.FLYING_SPEED) == null)
			this.getAttributes().registerAttribute(SharedMonsterAttributes.FLYING_SPEED);
			this.getAttribute(SharedMonsterAttributes.FLYING_SPEED).setBaseValue(${data.movementSpeed});
		</#if>
	}
}
<#-- @formatter:on -->
