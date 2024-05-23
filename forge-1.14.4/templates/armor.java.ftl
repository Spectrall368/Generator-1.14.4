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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">
package ${package}.item;

public abstract class ${name}Item extends ArmorItem {

	public ${name}Item(EquipmentSlotType type, Item.Properties properties) {
		super(new IArmorMaterial() {
			@Override public int getDurability(EquipmentSlotType type) {
				return new int[]{13, 15, 16, 11}[type.getIndex()] * ${data.maxDamage};
			}

			@Override public int getDamageReductionAmount(EquipmentSlotType type) {
				return new int[] { ${data.damageValueBoots}, ${data.damageValueLeggings}, ${data.damageValueBody}, ${data.damageValueHelmet} }[type.getIndex()];
			}

			@Override public int getEnchantability() {
				return ${data.enchantability};
			}

			@Override public net.minecraft.util.SoundEvent getSoundEvent() {
				<#if data.equipSound?has_content && data.equipSound.getUnmappedValue()?has_content>
				return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.equipSound}"));
				<#else>
				return null;
				</#if>
			}

			@Override public Ingredient getRepairMaterial() {
				return ${mappedMCItemsToIngredient(data.repairItems)};
			}

			@Override @OnlyIn(Dist.CLIENT) public String getName() {
				return "${registryname}";
			}

			@Override public float getToughness() {
				return ${data.toughness}f;
			}
		}, type, properties);
	}

	<#if data.enableHelmet>
	public static class Helmet extends ${name}Item {

		public Helmet() {
			super(EquipmentSlotType.HEAD, new Item.Properties()<#if data.enableHelmet>.group(${data.creativeTab})</#if>);
		}

		<#if data.helmetModelName != "Default" && data.getHelmetModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel();
			armorModel.bipedHead = new ${data.helmetModelName}().${data.helmetModelPart};
			armorModel.bipedHeadwear = new ${data.helmetModelName}().${data.helmetModelPart};
			armorModel.isSneak = living.isSneaking();
			armorModel.isSitting = defaultModel.isSitting;
			armorModel.isChild = living.isChild();
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.helmetSpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.helmetModelTexture?has_content && data.helmetModelTexture != "From armor">
			return "${modid}:textures/entities/${data.helmetModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@onArmorTick data.onHelmetTick/>
	}
	</#if>

	<#if data.enableBody>
	public static class Chestplate extends ${name}Item {

		public Chestplate() {
			super(EquipmentSlotType.CHEST, new Item.Properties()<#if data.enableBody>.group(${data.creativeTab})</#if>);
		}

		<#if data.bodyModelName != "Default" && data.getBodyModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel();
			armorModel.bipedBody = new ${data.bodyModelName}().${data.bodyModelPart};

			<#if data.armsModelPartL?has_content>
			armorModel.bipedLeftArm = new ${data.bodyModelName}().${data.armsModelPartL};
			</#if>
			<#if data.armsModelPartR?has_content>
			armorModel.bipedRightArm = new ${data.bodyModelName}().${data.armsModelPartR};
			</#if>

			armorModel.isSneak = living.isSneaking();
			armorModel.isSitting = defaultModel.isSitting;
			armorModel.isChild = living.isChild();
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.bodySpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.bodyModelTexture?has_content && data.bodyModelTexture != "From armor">
			return "${modid}:textures/entities/${data.bodyModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@onArmorTick data.onBodyTick/>
	}
	</#if>

	<#if data.enableLeggings>
	public static class Leggings extends ${name}Item {

		public Leggings() {
			super(EquipmentSlotType.LEGS, new Item.Properties()<#if data.enableLeggings>.group(${data.creativeTab})</#if>);
		}

		<#if data.leggingsModelName != "Default" && data.getLeggingsModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel();
			armorModel.bipedBody = new ${data.bodyModelName}().${data.bodyModelPart};

			<#if data.leggingsModelPartL?has_content>
			armorModel.bipedLeftLeg = new ${data.leggingsModelName}().${data.leggingsModelPartL};
			</#if>
			<#if data.leggingsModelPartR?has_content>
			armorModel.bipedRightLeg = new ${data.leggingsModelName}().${data.leggingsModelPartR};
			</#if>

			armorModel.isSneak = living.isSneaking();
			armorModel.isSitting = defaultModel.isSitting;
			armorModel.isChild = living.isChild();
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.leggingsSpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.leggingsModelTexture?has_content && data.leggingsModelTexture != "From armor">
			return "${modid}:textures/entities/${data.leggingsModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_2.png";
			</#if>
		}

		<@onArmorTick data.onLeggingsTick/>
	}
	</#if>

	<#if data.enableBoots>
	public static class Boots extends ${name}Item {

		public Boots() {
			super(EquipmentSlotType.FEET, new Item.Properties()<#if data.enableBoots>.group(${data.creativeTab})</#if>);
		}

		<#if data.bootsModelName != "Default" && data.getBootsModel()??>
		@Override @OnlyIn(Dist.CLIENT) public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
			BipedModel armorModel = new BipedModel();

			<#if data.bootsModelPartL?has_content>
			armorModel.bipedLeftLeg = new ${data.bootsModelName}().${data.bootsModelPartL};
			</#if>
			<#if data.bootsModelPartR?has_content>
			armorModel.bipedRightLeg = new ${data.bootsModelName}().${data.bootsModelPartR};
			</#if>

			armorModel.isSneak = living.isSneaking();
			armorModel.isSitting = defaultModel.isSitting;
			armorModel.isChild = living.isChild();
			return armorModel;
		}
		</#if>

		<@addSpecialInformation data.bootsSpecialInfo/>

		@Override public String getArmorTexture(ItemStack stack, Entity entity, EquipmentSlotType slot, String type) {
			<#if data.bootsModelTexture?has_content && data.bootsModelTexture != "From armor">
			return "${modid}:textures/entities/${data.bootsModelTexture}";
			<#else>
			return "${modid}:textures/models/armor/${data.armorTextureFile}_layer_1.png";
			</#if>
		}

		<@onArmorTick data.onBootsTick/>
	}
	</#if>
}
<#-- @formatter:on -->
