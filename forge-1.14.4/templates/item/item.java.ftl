<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
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
<#include "../procedures.java.ftl">
<#include "../mcitems.ftl">
<#include "../triggers.java.ftl">
package ${package}.item;

<#compress>
public class ${name}Item extends Item {

	public ${name}Item() {
		super(new Item.Properties()
				.group(${data.creativeTab})
				<#if data.hasInventory()>
				.maxStackSize(1)
				<#elseif data.damageCount != 0>
				.maxDamage(${data.damageCount})
				<#else>
				.maxStackSize(${data.stackSize})
				</#if>
				.rarity(Rarity.${data.rarity})
				<#if data.isFood>
				.food((new Food.Builder())
					.hunger(${data.nutritionalValue})
					.saturation(${data.saturation}f)
					<#if data.isAlwaysEdible>.setAlwaysEdible()</#if>
					<#if data.isMeat>.meat()</#if>
					.build())
				</#if>
		);
	}

	<#if data.hasNonDefaultAnimation()>
	@Override public UseAction getUseAction(ItemStack itemstack) {
		return UseAction.${data.animation?upper_case};
	}
	</#if>

	<#if data.stayInGridWhenCrafting>
		@Override public boolean hasContainerItem() {
			return true;
		}

		<#if data.recipeRemainder?? && !data.recipeRemainder.isEmpty()>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return ${mappedMCItemToItemStackCode(data.recipeRemainder, 1)};
			}
		<#elseif data.damageOnCrafting && data.damageCount != 0>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				ItemStack retval = new ItemStack(this);
				retval.setDamage(itemstack.getDamage() + 1);
				if(retval.getDamage() >= retval.getMaxDamage()) {
					return ItemStack.EMPTY;
				}
				return retval;
			}

			@Override public boolean isRepairable(ItemStack itemstack) {
				return false;
			}
		<#else>
			@Override public ItemStack getContainerItem(ItemStack itemstack) {
				return new ItemStack(this);
			}

			<#if data.damageCount != 0>
			@Override public boolean isRepairable(ItemStack itemstack) {
				return false;
			}
			</#if>
		</#if>
	</#if>

	<#if data.enchantability != 0>
	@Override public int getItemEnchantability() {
		return ${data.enchantability};
	}
	</#if>

	<#if (!data.isFood && data.useDuration != 0) || (data.isFood && data.useDuration != 32)>
	@Override public int getUseDuration(ItemStack itemstack) {
		return ${data.useDuration};
	}
	</#if>

	<#if data.toolType != 1>
	@Override public float getDestroySpeed(ItemStack par1ItemStack, BlockState par2Block) {
		return ${data.toolType}f;
	}
	</#if>

	<#if data.enableMeleeDamage>
		@Override public Multimap<String, AttributeModifier> getAttributeModifiers(EquipmentSlotType equipmentSlot) {
			if (equipmentSlot == EquipmentSlotType.MAINHAND) {
				ImmutableMultimap.Builder<String, AttributeModifier> builder = ImmutableMultimap.builder();
				builder.putAll(super.getAttributeModifiers(equipmentSlot));
				builder.put(SharedMonsterAttributes.ATTACK_DAMAGE.getName(), new AttributeModifier(ATTACK_DAMAGE_MODIFIER, "Item modifier", ${data.damageVsEntity - 1}d, AttributeModifier.Operation.ADDITION));
				builder.put(SharedMonsterAttributes.ATTACK_SPEED.getName(), new AttributeModifier(ATTACK_SPEED_MODIFIER, "Item modifier", -2.4, AttributeModifier.Operation.ADDITION));
				return builder.build();
			}
			return super.getAttributeModifiers(equipmentSlot);
		}
	</#if>

	<@hasGlow data.glowCondition/>

	<#if data.destroyAnyBlock>
	@Override public boolean canHarvestBlock(BlockState state) {
		return true;
	}
	</#if>

	<@addSpecialInformation data.specialInformation/>

	<#if hasProcedure(data.onRightClickedInAir) || data.hasInventory() || (hasProcedure(data.onStoppedUsing) && (data.useDuration > 0)) || data.enableRanged>
	@Override public ActionResult<ItemStack> onItemRightClick(World world, PlayerEntity entity, Hand hand) {
		<#if data.enableRanged>
		ActionResult<ItemStack> ar = new ActionResult(ActionResultType.FAIL, entity.getHeldItem(hand));
		<#else>
		ActionResult<ItemStack> ar = super.onItemRightClick(world, entity, hand);
		</#if>

		<#if (hasProcedure(data.onStoppedUsing) && (data.useDuration > 0)) || data.enableRanged>
			<#if data.enableRanged>
				<#if hasProcedure(data.rangedUseCondition)>
				if (<@procedureCode data.rangedUseCondition, {
					"x": "entity.posX",
					"y": "entity.posY",
					"z": "entity.posZ",
					"world": "world",
					"entity": "entity",
					"itemstack": "ar.getResult()"
				}, false/>)
				</#if>
				if (entity.abilities.isCreativeMode || findAmmo(entity) != ItemStack.EMPTY) {
					ar = new ActionResult(ActionResultType.SUCCESS, entity.getHeldItem(hand));
					entity.setActiveHand(hand);
				}
			<#else>
				entity.setActiveHand(hand);
			</#if>
		</#if>

		<#if data.hasInventory()>
		if(entity instanceof ServerPlayerEntity) {
			NetworkHooks.openGui((ServerPlayerEntity) entity, new INamedContainerProvider() {
				@Override public ITextComponent getDisplayName() {
					return new StringTextComponent("${data.name}");
				}

				@Override public Container createMenu(int id, PlayerInventory inventory, PlayerEntity player) {
					PacketBuffer packetBuffer = new PacketBuffer(Unpooled.buffer());
					packetBuffer.writeBlockPos(entity.getPosition());
					packetBuffer.writeByte(hand == Hand.MAIN_HAND ? 0 : 1);
					return new ${data.guiBoundTo}Menu(id, inventory, packetBuffer);
				}
			}, buf -> {
				buf.writeBlockPos(entity.getPosition());
				buf.writeByte(hand == Hand.MAIN_HAND ? 0 : 1);
			});
		}
		</#if>

		<#if hasProcedure(data.onRightClickedInAir)>
			<@procedureCode data.onRightClickedInAir, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "world",
				"entity": "entity",
				"itemstack": "ar.getResult()"
			}/>
		</#if>
		return ar;
	}
	</#if>

	<#if hasProcedure(data.onFinishUsingItem) || data.hasEatResultItem()>
		@Override public ItemStack onItemUseFinish(ItemStack itemstack, World world, LivingEntity entity) {
			ItemStack retval =
				<#if data.hasEatResultItem()>
					${mappedMCItemToItemStackCode(data.eatResultItem, 1)};
				</#if>
			super.onItemUseFinish(itemstack, world, entity);

			<#if hasProcedure(data.onFinishUsingItem)>
				double x = entity.posX;
				double y = entity.posY;
				double z = entity.posZ;
				<@procedureOBJToCode data.onFinishUsingItem/>
			</#if>

			<#if data.hasEatResultItem()>
				if (itemstack.isEmpty()) {
					return retval;
				} else {
					if (entity instanceof PlayerEntity && !((PlayerEntity) entity).abilities.isCreativeMode) {
						if (!((PlayerEntity) entity).inventory.addItemStackToInventory(retval))
							((PlayerEntity) entity).dropItem(retval, false);
					}
					return itemstack;
				}
			<#else>
				return retval;
			</#if>
		}
	</#if>

	<@onItemUsedOnBlock data.onRightClickedOnBlock/>

	<@onEntityHitWith data.onEntityHitWith, (data.damageCount != 0 && data.enableMeleeDamage), 1/>

	<@onEntitySwing data.onEntitySwing/>

	<@onCrafted data.onCrafted/>

	<@onItemTick data.onItemInUseTick, data.onItemInInventoryTick/>

	<@onDroppedByPlayer data.onDroppedByPlayer/>

	<#if data.hasInventory()>
	@Override public ICapabilityProvider initCapabilities(ItemStack stack, @Nullable CompoundNBT compound) {
		return new ${name}InventoryCapability();
	}

	@Override public CompoundNBT getShareTag(ItemStack stack) {
		CompoundNBT nbt = stack.getOrCreateTag();
		stack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> nbt.put("Inventory", ((ItemStackHandler) capability).serializeNBT()));
		return nbt;
	}

	@Override public void readShareTag(ItemStack stack, @Nullable CompoundNBT nbt) {
		super.readShareTag(stack, nbt);
		if(nbt != null)
			stack.getCapability(CapabilityItemHandler.ITEM_HANDLER_CAPABILITY, null).ifPresent(capability -> ((ItemStackHandler) capability).deserializeNBT((CompoundNBT) nbt.get("Inventory")));
	}
	</#if>

	<#if hasProcedure(data.onStoppedUsing) || (data.enableRanged && !data.shootConstantly)>
		@Override public void onPlayerStoppedUsing(ItemStack itemstack, World world, LivingEntity entity, int time) {
			<#if hasProcedure(data.onStoppedUsing)>
				<@procedureCode data.onStoppedUsing, {
					"x": "entity.posX",
					"y": "entity.posY",
					"z": "entity.posZ",
					"world": "world",
					"entity": "entity",
					"itemstack": "itemstack",
					"time": "time"
				}/>
			</#if>
			<#if data.enableRanged && !data.shootConstantly>
				if (!world.isRemote && entity instanceof ServerPlayerEntity) {
					<#if data.rangedItemChargesPower>
						float pullingPower = BowItem.getArrowVelocity(this.getUseDuration(itemstack) - time);
						if (pullingPower < 0.1)
							return;
					</#if>
					<@arrowShootCode/>
				}
			</#if>
		}
	</#if>

	<#if data.enableRanged && data.shootConstantly>
		@Override public void onUsingTick(ItemStack itemstack, LivingEntity entity, int count) {
			World world = entity.world;
			if (!entity.world.isRemote && entity instanceof ServerPlayerEntity) {
				<@arrowShootCode/>
				entity.stopActiveHand();
			}
		}
	</#if>

	<#if data.enableRanged>
	private ItemStack findAmmo(PlayerEntity player) {
		ItemStack stack = ShootableItem.getHeldAmmo(player, e -> e.getItem() == ${generator.map(projectile, "projectiles", 2)});
		if(stack == ItemStack.EMPTY) {
			for (int i = 0; i < player.inventory.mainInventory.size(); i++) {
				ItemStack teststack = player.inventory.mainInventory.get(i);
				if(teststack != null && teststack.getItem() == ${generator.map(projectile, "projectiles", 2)}) {
					stack = teststack;
					break;
				}
			}
		}
		return stack;
	}
	</#if>
}

<#macro arrowShootCode>
	<#assign projectile = data.projectile.getUnmappedValue()>
	ItemStack stack = findAmmo((ServerPlayerEntity) entity);
	if (((ServerPlayerEntity) entity).abilities.isCreativeMode || stack != ItemStack.EMPTY) {
		<#assign projectileClass = generator.map(projectile, "projectiles", 0)>
		<#if projectile.startsWith("CUSTOM:")>
			${projectileClass} projectile = ${projectileClass}.shoot(world, entity, random<#if data.rangedItemChargesPower>, pullingPower</#if>);
		<#else>
			${projectileClass} projectile = new ${projectileClass}(world, entity);
			projectile.shoot(entity, entity.rotationPitch, entity.rotationYaw, 0, <#if data.rangedItemChargesPower>pullingPower * </#if>3.15f, 1.0F);
			world.addEntity(projectile);
			world.playSound(null, entity.posX, entity.posY, entity.posZ, ForgeRegistries.SOUND_EVENTS
				.getValue(new ResourceLocation("entity.arrow.shoot")), SoundCategory.PLAYERS, 1, 1f / (random.nextFloat() * 0.5f + 1));
		</#if>

		<#if data.damageCount != 0>
		itemstack.damageItem(1, entity, e -> e.sendBreakAnimation(entity.getActiveHand()));
		</#if>

		if (((ServerPlayerEntity) entity).abilities.isCreativeMode) {
			projectile.pickupStatus = AbstractArrowEntity.PickupStatus.CREATIVE_ONLY;
		} else {
			if (stack.isDamageable()) {
				if (stack.attemptDamageItem(1, random, ((ServerPlayerEntity) entity))) {
					stack.shrink(1);
					stack.setDamage(0);
					if (stack.isEmpty())
						((ServerPlayerEntity) entity).inventory.deleteStack(stack);
				}
			} else {
				stack.shrink(1);
				if (stack.isEmpty())
				   ((ServerPlayerEntity) entity).inventory.deleteStack(stack);
			}
		}

		<#if hasProcedure(data.onRangedItemUsed)>
			<@procedureCode data.onRangedItemUsed, {
				"x": "entity.posX",
				"y": "entity.posY",
				"z": "entity.posZ",
				"world": "world",
				"entity": "entity",
				"itemstack": "itemstack"
			}/>
		</#if>
	}
</#macro>
</#compress>
<#-- @formatter:on -->
