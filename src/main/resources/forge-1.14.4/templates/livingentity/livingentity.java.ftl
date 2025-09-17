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
package ${package}.entity;

import net.minecraft.network.datasync.DataParameter;
<#assign interfaces = []>
<#assign extendsClass = "Creature">
<#if data.aiBase != "(none)">
	<#assign extendsClass = data.aiBase>
<#else>
	<#assign extendsClass = data.mobBehaviourType?replace("Mob", "Monster")?replace("Raider", "AbstractRaider")>
</#if>
<#if data.breedable>
	<#assign extendsClass = "Animal">
</#if>
<#if (data.tameable && data.breedable)>
	<#assign extendsClass = "Tameable">
</#if>
<#if data.ranged>
	<#assign interfaces += ["IRangedAttackMob"]>
</#if>

public class ${name}Entity extends ${extendsClass}Entity <#if interfaces?size gt 0>implements ${interfaces?join(",")}</#if> {

	<#if data.spawnThisMob>
	private static final Set<ResourceLocation> SPAWN_BIOMES =
	<#if data.restrictionBiomes?has_content>
	ImmutableSet.of(
		<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
		    <#assign expandedBiomes = expandBiomeTag(restrictionBiome)>
		    <#list expandedBiomes as expandedBiome>
			new ResourceLocation("${expandedBiome}")<#sep>,
		    </#list><#sep>,
        </#list>
        )
        <#else>
        null
        </#if>;
	</#if>

	<#list data.entityDataEntries as entry>
		<#if entry.value().getClass().getSimpleName() == "Integer">
			public static final DataParameter<Integer> DATA_${entry.property().getName()} = EntityDataManager.createKey(${name}Entity.class, DataSerializers.VARINT);
		<#elseif entry.value().getClass().getSimpleName() == "Boolean">
			public static final DataParameter<Boolean> DATA_${entry.property().getName()} = EntityDataManager.createKey(${name}Entity.class, DataSerializers.BOOLEAN);
		<#elseif entry.value().getClass().getSimpleName() == "String">
			public static final DataParameter<String> DATA_${entry.property().getName()} = EntityDataManager.createKey(${name}Entity.class, DataSerializers.STRING);
		</#if>
	</#list>

	<#if data.isBoss>
	private final ServerBossInfo bossInfo = new ServerBossInfo(this.getDisplayName(),
		BossInfo.Color.${data.bossBarColor}, BossInfo.Overlay.${data.bossBarType});
	</#if>

	public ${name}Entity(FMLPlayMessages.SpawnEntity packet, World world) {
    	this(${JavaModName}Entities.${REGISTRYNAME}.get(), world);
    }

	public ${name}Entity(EntityType<${name}Entity> type, World world) {
    	super(type, world);
		stepHeight = ${data.stepHeight}f;
		experienceValue = ${data.xpAmount};
		setNoAI(${(!data.hasAI)});

		<#if data.mobLabel?has_content>
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

						float f2 = - (float) (MathHelper.atan2(dy, (float) MathHelper.sqrt(dx * dx + dz * dz)) * (180 / Math.PI));
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

		<#if data.boundingBoxScale?? && data.boundingBoxScale.getFixedValue() != 1 && !hasProcedure(data.boundingBoxScale)>
		recalculateSize();
		</#if>
	}

	@Override public IPacket<?> createSpawnPacket() {
		return NetworkHooks.getEntitySpawningPacket(this);
	}

	<#if data.entityDataEntries?has_content>
	@Override protected void registerData() {
		super.registerData();
		<#list data.entityDataEntries as entry>
			this.dataManager.register(DATA_${entry.property().getName()}, ${entry.value()?is_string?then("\"" + entry.value() + "\"", entry.value())});
		</#list>
	}
	</#if>

	<#if data.flyingMob>
	@Override protected PathNavigator createNavigator(World world) {
		return new FlyingPathNavigator(this, world);
	}
	<#elseif data.waterMob>
	@Override protected PathNavigator createNavigator(World world) {
		return new SwimmerPathNavigator(this, world);
	}
	</#if>

	<#if data.aiBase == "Villager">
	@Override public ITextComponent getDisplayName() {
		return this.getType().getName();
	}
	</#if>

	<#if data.hasAI>
	@Override protected void registerGoals() {
		super.registerGoals();

		<#if aicode??>
			<#if aiblocks?seq_contains("doors_open") || aiblocks?seq_contains("doors_close")>
				this.getNavigator().getNodeProcessor().setCanOpenDoors(true);
			</#if>
            ${aicode}
        </#if>

        <#if data.ranged>
            this.goalSelector.addGoal(1, new RangedAttackGoal(this, 1.25, ${data.rangedAttackInterval}, ${data.rangedAttackRadius}f) {
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

	${extra_templates_code}

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

   	<#if data.livingSound?has_content && data.livingSound.getMappedValue()?has_content>
	@Override public SoundEvent getAmbientSound() {
		return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.livingSound}"));
	}
	</#if>

   	<#if data.stepSound?has_content && data.stepSound.getMappedValue()?has_content>
	@Override public void playStepSound(BlockPos pos, BlockState blockIn) {
		this.playSound(ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.stepSound}")), 0.15f, 1);
	}
	</#if>

	<#if data.hurtSound?has_content && data.hurtSound.getMappedValue()?has_content>
	@Override public SoundEvent getHurtSound(DamageSource ds) {
		return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.hurtSound}"));
	}
	</#if>

	<#if data.deathSound?has_content && data.deathSound.getMappedValue()?has_content>
	@Override public SoundEvent getDeathSound() {
		return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.deathSound}"));
	}
	</#if>

	<#if data.mobBehaviourType == "Raider">
	@Override public SoundEvent getRaidLossSound() {
		<#if data.raidCelebrationSound?has_content && data.raidCelebrationSound.getMappedValue()?has_content>
		return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.raidCelebrationSound}"));
		<#else>
		return null;
		</#if>
	}
	</#if>

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
	@Override public void fall(float l, float d) {
		<#if !data.flyingMob>
			super.fall(l, d);
		</#if>
		<#if hasProcedure(data.whenMobFalls)>
			<@procedureCode data.whenMobFalls, {
				"x": "this.posX",
				"y": "this.posY",
				"z": "this.posZ",
				"entity": "this",
				"world": "this.world",
				"damagesource": "this.getLastDamageSource()"
			}/>
		</#if>
	}
    </#if>

	<#if hasProcedure(data.whenMobIsHurt) || data.immuneToArrows || data.immuneToFallDamage
		|| data.immuneToCactus || data.immuneToDrowning || data.immuneToLightning || data.immuneToPotions
		|| data.immuneToPlayer || data.immuneToExplosion || data.immuneToTrident || data.immuneToAnvil
		|| data.immuneToDragonBreath || data.immuneToWither>
	@Override public boolean attackEntityFrom(DamageSource damagesource, float amount) {
		<#if hasProcedure(data.whenMobIsHurt)>
			double x = this.posX;
			double y = this.posY;
			double z = this.posZ;
			World world = this.world;
			Entity entity = this;
			Entity sourceentity = damagesource.getTrueSource();
			Entity immediatesourceentity = damagesource.getImmediateSource();
			<#if hasReturnValueOf(data.whenMobIsHurt, "logic")>
			if (<@procedureOBJToConditionCode data.whenMobIsHurt false true/>)
				return false;
			<#else>
				<@procedureOBJToCode data.whenMobIsHurt/>
			</#if>
		</#if>
		<#if data.immuneToArrows>
			if (damagesource.getImmediateSource() instanceof AbstractArrowEntity)
				return false;
		</#if>
		<#if data.immuneToPlayer>
			if (damagesource.getImmediateSource() instanceof PlayerEntity)
				return false;
		</#if>
		<#if data.immuneToPotions>
			if (damagesource.getImmediateSource() instanceof PotionEntity || damagesource.getImmediateSource() instanceof AreaEffectCloudEntity)
				return false;
		</#if>
		<#if data.immuneToFallDamage>
			if (damagesource == DamageSource.FALL)
				return false;
		</#if>
		<#if data.immuneToCactus>
			if (damagesource == DamageSource.CACTUS)
				return false;
		</#if>
		<#if data.immuneToDrowning>
			if (damagesource == DamageSource.DROWN)
				return false;
		</#if>
		<#if data.immuneToLightning>
			if (damagesource == DamageSource.LIGHTNING_BOLT)
				return false;
		</#if>
		<#if data.immuneToExplosion>
			if (damagesource.isExplosion())
				return false;
		</#if>
		<#if data.immuneToTrident>
			if (damagesource.getDamageType().equals("trident"))
				return false;
		</#if>
		<#if data.immuneToAnvil>
			if (damagesource == DamageSource.ANVIL)
				return false;
		</#if>
		<#if data.immuneToDragonBreath>
			if (damagesource == DamageSource.DRAGON_BREATH)
				return false;
		</#if>
		<#if data.immuneToWither>
			if (damagesource == DamageSource.WITHER || (damagesource.getDamageType().equals("mob") && damagesource.getImmediateSource() instanceof WitherSkullEntity))
				return false;
		</#if>
		return super.attackEntityFrom(damagesource, amount);
	}
    </#if>

	<#if data.immuneToExplosion>
	@Override public boolean isImmuneToExplosions() {
		return true;
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
			"immediatesourceentity": "source.getImmediateSource()",
			"entity": "this",
			"world": "this.world",
			"damagesource": "source"
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

	<#if data.guiBoundTo?has_content>
	private final ItemStackHandler inventory = new ItemStackHandler(${data.inventorySize})
	<#if data.inventoryStackSize != 99>
	{
		@Override public int getSlotLimit(int slot) {
			return ${data.inventoryStackSize};
		}
	}
	</#if>;

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
	</#if>

	<#if data.entityDataEntries?has_content || data.guiBoundTo?has_content>
	@Override public void writeAdditional(CompoundNBT compound) {
		super.writeAdditional(compound);
		<#list data.entityDataEntries as entry>
			<#if entry.value().getClass().getSimpleName() == "Integer">
			compound.putInt("Data${entry.property().getName()}", this.dataManager.get(DATA_${entry.property().getName()}));
			<#elseif entry.value().getClass().getSimpleName() == "Boolean">
			compound.putBoolean("Data${entry.property().getName()}", this.dataManager.get(DATA_${entry.property().getName()}));
			<#elseif entry.value().getClass().getSimpleName() == "String">
			compound.putString("Data${entry.property().getName()}", this.dataManager.get(DATA_${entry.property().getName()}));
			</#if>
		</#list>
		<#if data.guiBoundTo?has_content>
		compound.put("InventoryCustom", inventory.serializeNBT());
		</#if>
	}

	@Override public void readAdditional(CompoundNBT compound) {
    		super.readAdditional(compound);
		<#list data.entityDataEntries as entry>
			if (compound.contains("Data${entry.property().getName()}"))
			<#if entry.value().getClass().getSimpleName() == "Integer">
				this.dataManager.set(DATA_${entry.property().getName()}, compound.getInt("Data${entry.property().getName()}"));
			<#elseif entry.value().getClass().getSimpleName() == "Boolean">
				this.dataManager.set(DATA_${entry.property().getName()}, compound.getBoolean("Data${entry.property().getName()}"));
			<#elseif entry.value().getClass().getSimpleName() == "String">
				this.dataManager.set(DATA_${entry.property().getName()}, compound.getString("Data${entry.property().getName()}"));
			</#if>
		</#list>
		<#if data.guiBoundTo?has_content>
		if (compound.get("InventoryCustom") instanceof CompoundNBT)
			inventory.deserializeNBT((CompoundNBT) compound.get("InventoryCustom"));
		</#if>
	}
	</#if>

	<#if hasProcedure(data.onRightClickedOn) || data.ridable || (data.tameable && data.breedable) || data.guiBoundTo?has_content>
	@Override public boolean processInteract(PlayerEntity sourceentity, Hand hand) {
		ItemStack itemstack = sourceentity.getHeldItem(hand);
		ActionResultType retval = ActionResult.newResult(ActionResultType.SUCCESS, this.world.isRemote()).getType();

		<#if data.guiBoundTo?has_content>
			<#if data.ridable>
				if (sourceentity.isSneaking()) {
			</#if>
				if(sourceentity instanceof ServerPlayerEntity) {
					NetworkHooks.openGui((ServerPlayerEntity) sourceentity, new INamedContainerProvider() {

						@Override public ITextComponent getDisplayName() {
							return new StringTextComponent("${data.mobName}");
						}

						@Override public Container createMenu(int id, PlayerInventory inventory, PlayerEntity player) {
							PacketBuffer packetBuffer = new PacketBuffer(Unpooled.buffer());
							packetBuffer.writeBlockPos(sourceentity.getPosition());
							packetBuffer.writeByte(0);
							packetBuffer.writeVarInt(${name}Entity.this.getEntityId());
							return new ${data.guiBoundTo}Menu(id, inventory, packetBuffer);
						}

					}, buf -> {
						buf.writeBlockPos(sourceentity.getPosition());
						buf.writeByte(0);
						buf.writeVarInt(this.getEntityId());
					});
				}
			<#if data.ridable>
					return this.world.isRemote();
				}
			</#if>
		</#if>

		<#if (data.tameable && data.breedable)>
			Item item = itemstack.getItem();
			if (itemstack.getItem() instanceof SpawnEggItem) {
				retval = ActionResult.newResult(ActionResultType.SUCCESS, super.processInteract(sourceentity, hand)).getType();
			} else if (this.world.isRemote()) {
				retval = (this.isTamed() && this.isOwner(sourceentity) || this.isBreedingItem(itemstack))
						? ActionResult.newResult(ActionResultType.SUCCESS, this.world.isRemote()).getType() : ActionResultType.PASS;
			} else {
				if (this.isTamed()) {
					if (this.isOwner(sourceentity)) {
						if (item.isFood() && this.isBreedingItem(itemstack) && this.getHealth() < this.getMaxHealth()) {
							this.consumeItemFromStack(sourceentity, itemstack);
							this.heal((float)item.getFood().getHealing());
							retval = ActionResult.newResult(ActionResultType.SUCCESS, this.world.isRemote()).getType();
						} else if (this.isBreedingItem(itemstack) && this.getHealth() < this.getMaxHealth()) {
							this.consumeItemFromStack(sourceentity, itemstack);
							this.heal(4);
							retval = ActionResult.newResult(ActionResultType.SUCCESS, this.world.isRemote()).getType();
						} else {
							retval = ActionResult.newResult(ActionResultType.SUCCESS, super.processInteract(sourceentity, hand)).getType();
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
					retval = ActionResult.newResult(ActionResultType.SUCCESS, this.world.isRemote()).getType();
				} else {
					retval = ActionResult.newResult(ActionResultType.SUCCESS, super.processInteract(sourceentity, hand)).getType();
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
				return <@procedureOBJToInteractionResultCode data.onRightClickedOn/> != ActionResultType.FAIL;
			<#else>
				<@procedureOBJToCode data.onRightClickedOn/>
				return retval != ActionResultType.FAIL;
			</#if>
		<#else>
			return retval != ActionResultType.FAIL;
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
			"immediatesourceentity": "entity.getLastDamageSource().getImmediateSource()",
			"world": "this.world",
			"damagesource": "entity.getLastDamageSource()"
		}/>
	}
    </#if>

	<#if hasProcedure(data.onMobTickUpdate) || hasProcedure(data.boundingBoxScale)>
	@Override public void baseTick() {
		super.baseTick();
		<#if hasProcedure(data.onMobTickUpdate)>
			<@procedureCode data.onMobTickUpdate, {
				"x": "this.posX",
				"y": "this.posY",
				"z": "this.posZ",
				"entity": "this",
				"world": "this.world"
			}/>
		</#if>
		<#if hasProcedure(data.boundingBoxScale)>
			this.recalculateSize();
		</#if>
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
				${name}EntityProjectile entityarrow = new ${name}EntityProjectile(${JavaModName}Entities.${REGISTRYNAME}_PROJECTILE.get(), this, this.world);
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
			${name}Entity retval = ${JavaModName}Entities.${REGISTRYNAME}.get().create(this.world);
			retval.onInitialSpawn(this.world, this.world.getDifficultyForLocation(retval.getPosition()), SpawnReason.BREEDING, null, null);
			return retval;
		}

		@Override public boolean isBreedingItem(ItemStack stack) {
			return ${mappedMCItemsToIngredient(data.breedTriggerItems)}.test(stack);
		}
    </#if>

	<#if data.waterMob>
    	@Override public boolean isNotColliding(IWorldReader world) {
		return world.checkNoEntityCollision(this);
	}
	</#if>

	<#if data.breatheUnderwater?? && (hasProcedure(data.breatheUnderwater) || data.breatheUnderwater.getFixedValue())>
	@Override public boolean canBreatheUnderwater() {
		double x = this.posX;
		double y = this.posY;
		double z = this.posZ;
		World world = this.world;
		Entity entity = this;
		return <@procedureOBJToConditionCode data.breatheUnderwater true false/>;
	}
	</#if>

	<#if data.pushedByFluids?? && (hasProcedure(data.pushedByFluids) || !data.pushedByFluids.getFixedValue())>
	@Override public boolean isPushedByWater() {
		double x = this.posX;
		double y = this.posY;
		double z = this.posZ;
		World world = this.world;
		Entity entity = this;
		return <@procedureOBJToConditionCode data.pushedByFluids false false/>;
	}
	</#if>

	<#if data.disableCollisions>
	@Override public boolean canBePushed() {
		return false;
	}

   	@Override protected void collideWithEntity(Entity entityIn) {}

   	@Override protected void collideWithNearbyEntities() {}
	</#if>

	<#if data.solidBoundingBox?? && (hasProcedure(data.solidBoundingBox) || data.solidBoundingBox.getFixedValue())>
	@Override public AxisAlignedBB getCollisionBox(Entity entity) {
		return entity.getBoundingBox();
	}

	@Override public AxisAlignedBB getCollisionBoundingBox() {
		<#if hasProcedure(data.solidBoundingBox)>
		Entity entity = this;
		World world = entity.world;
		double x = entity.posX;
		double y = entity.posY;
		double z = entity.posZ;
		</#if>
		return <@procedureOBJToConditionCode data.solidBoundingBox true false/> ? this.getBoundingBox() : null;
	}
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

				if (entity instanceof LivingEntity) {
					this.setAIMoveSpeed((float) this.getAttribute(SharedMonsterAttributes.MOVEMENT_SPEED).getValue());

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
			this.jumpMovementFactor = 0.02F;
			</#if>

			super.travel(dir);
		}
    </#if>

	<#if hasProcedure(data.boundingBoxScale) || (data.boundingBoxScale?? && data.boundingBoxScale.getFixedValue() != 1)>
	@Override public EntitySize getSize(Pose pose) {
		<#if hasProcedure(data.boundingBoxScale)>
			Entity entity = this;
			World world = this.world;
			double x = this.posX;
			double y = this.posY;
			double z = this.posZ;
			return super.getSize(pose).scale((float) <@procedureOBJToNumberCode data.boundingBoxScale/>);
		<#else>
			return super.getSize(pose).scale(${data.boundingBoxScale.getFixedValue()}f);
		</#if>
	}
	</#if>

	<#if data.flyingMob>
	@Override protected void updateFallState(double y, boolean onGroundIn, BlockState state, BlockPos pos) {}

   	@Override public void setNoGravity(boolean ignored) {
		super.setNoGravity(true);
	}
    </#if>

    <#if data.flyingMob>
    public void livingTick() {
		super.livingTick();

		this.setNoGravity(true);
	}
    </#if>

	public static void init() {
		<#if data.spawnThisMob>
		for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
		<#if data.restrictionBiomes?has_content>
            if (SPAWN_BIOMES.contains(ForgeRegistries.BIOMES.getKey(biome)))
            </#if>

			biome.getSpawns(${generator.map(data.mobSpawningType, "mobspawntypes")}).add(new Biome.SpawnListEntry(${JavaModName}Entities.${REGISTRYNAME}.get(), ${data.spawningProbability},
		        ${data.minNumberOfMobsPerGroup}, ${data.maxNumberOfMobsPerGroup}));
		}

			<#if data.mobSpawningType == "creature">
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${REGISTRYNAME}.get(),
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
							(world.getBlockState(pos.down()).getMaterial() == Material.ORGANIC && world.getLightSubtracted(pos, 0) > 8)
				</#if>
			);
			<#elseif data.mobSpawningType == "ambient" || data.mobSpawningType == "misc">
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${REGISTRYNAME}.get(),
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
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${REGISTRYNAME}.get(),
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
							(world.getBlockState(pos).getBlock() == Blocks.WATER && world.getBlockState(pos.up()).getBlock() == Blocks.WATER)
					</#if>
			);
			<#elseif data.mobSpawningType == "undergroundWaterCreature">
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${REGISTRYNAME}.get(),
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
					    return world.getFluidState(pos.down()).isTagged(FluidTags.WATER) && world.getBlockState(pos.up()).getBlock() == Blocks.WATER && pos.getY() >= (world.getSeaLevel() - 13) && pos.getY() <= world.getSeaLevel();
                    }
					</#if>
			);
			<#else>
			EntitySpawnPlacementRegistry.register(${JavaModName}Entities.${REGISTRYNAME}.get(),
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
			DungeonHooks.addDungeonMob(${JavaModName}Entities.${REGISTRYNAME}.get(), 180);
		</#if>
	}

	<#if data.mobBehaviourType == "Raider">
   	@Override public void func_213660_a(int num, boolean logic) {}
   	</#if>

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
<#function expandBiomeTag biomeTag>
    <#local result = []>

    <#if biomeTag?contains("#")>
        <#local biomeName = fixNamespace(biomeTag)>
        <#local tagKey = "BIOMES:" + biomeName?substring(1)>

        <#local tagFound = false>
        <#list w.getWorkspace().getTagElements()?keys as tagElement>
            <#if tagElement.toString().replace("mod:", modid + ":") == tagKey>
                <#local tagFound = true>
                <#local biomeValues = w.getWorkspace().getTagElements().get(tagElement)>
                <#list biomeValues as biomeValue>
                    <#if biomeValue?starts_with("#")>
                        <#local expandedSubValues = expandBiomeTag(biomeValue?replace("mod:", modid + ":"))>
                        <#list expandedSubValues as expandedSubValue>
                            <#local result = result + [expandedSubValue]>
                        </#list>
                    <#else>
                        <#local result = result + [generator.map(biomeValue, "biomes")]>
                    </#if>
                </#list>
                <#break>
            </#if>
        </#list>

        <#if !tagFound>
            <#local result = result + [biomeName?substring(1)]>
        </#if>
    <#else>
        <#local result = result + [biomeTag]>
    </#if>

    <#return result>
</#function>
<#function fixNamespace input>
    <#assign noHash = input?starts_with("#")?then(input?substring(1), input)/>

    <#if noHash?contains(":")>
        <#return input>
    <#else>
        <#assign result = "minecraft:" + noHash />
        <#return input?starts_with("#")?then("#" + result, result)/>
    </#if>
</#function>