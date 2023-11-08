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
<#include "mcitems.ftl">
<#include "procedures.java.ftl">
<#include "triggers.java.ftl">
package ${package}.item;

import net.minecraft.util.SoundEvent;
import java.util.function.Consumer;

public abstract class ${name}Item extends ArmorItem {

	public ${name}Item(EquipmentSlotType type, Item.Properties properties) {
		super(new ArmorMaterial() {
			@Override public int getDurability(EquipmentSlotType type) {
				return new int[]{13, 15, 16, 11}[type.getIndex()] * ${data.maxDamage};
			}

  		 	@Override public int getDamageReductionAmount(EquipmentSlotType type) {
				return new int[] { ${data.damageValueBoots}, ${data.damageValueLeggings}, ${data.damageValueBody}, ${data.damageValueHelmet} }[type.getIndex()];
			}

			@Override public int getEnchantability() {
				return ${data.enchantability};
			}

			@Override public SoundEvent getSoundEvent() {
				<#if data.equipSound?has_content && data.equipSound.getUnmappedValue()?has_content>
				return ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.equipSound}"));
				<#else>
				return SoundEvents.EMPTY;
				</#if>
			}

			@Override public Ingredient getRepairMaterial() {
				<#if data.repairItems?has_content>
				return Ingredient.fromStacks(
							<#list data.repairItems as repairItem>
							${mappedMCItemToItemStackCode(repairItem,1)}<#if repairItem?has_next>,</#if>
                					</#list>
						);
				<#else>
				return Ingredient.EMPTY;
				</#if>
			}

			@Override @OnlyIn(Dist.CLIENT) public String getName() {
				return "${registryname}";
			}

			@Override public float getToughness() {
				return 	${data.toughness}f;
			}
		}, type, properties);
	}

	<#if data.enableHelmet>
	public static class Helmet extends ${name}Item {

		public Helmet() {
			super(EquipmentSlotType.HEAD, new Item.Properties()<#if data.enableHelmet>.group(${data.creativeTab})</#if>);
		}

		<#if data.helmetModelName != "Default" && data.getHelmetModel()??>
				@Override public BipedModel getArmorModel(LivingEntity living, ItemStack stack, EquipmentSlotType slot, BipedModel defaultModel) {
					BipedModel armorModel = new BipedModel();
					armorModel.bipedHead = new ${data.helmetModelName}().${data.helmetModelPart};
					armorModel.isSneak = living.isSneaking();
					armorModel.isSitting = defaultModel.isSitting;
					armorModel.isChild = living.isChild();
					return armorModel;
				}
		</#if>

		<@addSpecialInformation data.helmetSpecialInformation/>

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

		<@addSpecialInformation data.bodySpecialInformation/>

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
					armorModel.bipedLeftLeg = new ${data.leggingsModelName}().${data.leggingsModelPartL};
					armorModel.bipedRightLeg = new ${data.leggingsModelName}().${data.leggingsModelPartR};
					armorModel.isSneak = living.isSneaking();
					armorModel.isSitting = defaultModel.isSitting;
					armorModel.isChild = living.isChild();
					return armorModel;
				}
		</#if>

		<@addSpecialInformation data.leggingsSpecialInformation/>

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
					armorModel.bipedLeftLeg = new ${data.bootsModelName}().${data.bootsModelPartL};
					armorModel.bipedRightLeg = new ${data.bootsModelName}().${data.bootsModelPartR};
					armorModel.isSneak = living.isSneaking();
					armorModel.isSitting = defaultModel.isSitting;
					armorModel.isChild = living.isChild();
					return armorModel;
				}
		</#if>

		<@addSpecialInformation data.bootsSpecialInformation/>

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
	<#if data.getArmorModelsCode()??>
	${data.getArmorModelsCode().toString()
		.replace("ModelRenderer", "RendererModel").replace("extends ModelBase", "extends EntityModel<Entity>")
		.replace("GlStateManager.translate", "GlStateManager.translated")
		.replace("GlStateManager.scale", "GlStateManager.scaled")
		.replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+e\\)",
					"setRotationAngles(Entity e, float f, float f1, float f2, float f3, float f4, float f5)")
		.replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+entity\\)",
					"setRotationAngles(Entity entity, float f, float f1, float f2, float f3, float f4, float f5)")
		.replaceAll("setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+e\\)", "setRotationAngles(e, f, f1, f2, f3, f4, f5)")
		.replaceAll("setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+entity\\)", "setRotationAngles(entity, f, f1, f2, f3, f4, f5)")}
	</#if>
}
<#-- @formatter:on -->
