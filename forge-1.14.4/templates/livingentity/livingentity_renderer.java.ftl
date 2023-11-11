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
<#include "../procedures.java.ftl">
package ${package}.client.renderer;

<#assign humanoid = false>
<#assign model = "BipedModel(0)">

<#if data.mobModelName == "Chicken">
	<#assign model = "ChickenModel()">
<#elseif data.mobModelName == "Cod">
	<#assign model = "CodModel()">
<#elseif data.mobModelName == "Cow">
	<#assign model = "CowModel()">
<#elseif data.mobModelName == "Creeper">
	<#assign model = "CreeperModel()">
<#elseif data.mobModelName == "Ghast">
	<#assign model = "GhastModel()">
<#elseif data.mobModelName == "Ocelot">
	<#assign model = "OcelotModel(0)">
<#elseif data.mobModelName == "Pig">
	<#assign model = "PigModel()">
<#elseif data.mobModelName == "Slime">
	<#assign model = "SlimeModel(0)">
<#elseif data.mobModelName == "Salmon">
	<#assign model = "SalmonModel()">
<#elseif data.mobModelName == "Spider">
	<#assign model = "SpiderModel()">
<#elseif data.mobModelName == "Villager">
	<#assign model = "VillagerModel(0)">
<#elseif data.mobModelName == "Silverfish">
	<#assign model = "SilverfishModel()">
<#elseif data.mobModelName == "Witch">
	<#assign model = "WitchModel(0)">
<#elseif !data.isBuiltInModel()>
	<#assign model = data.mobModelName + "()">
<#else>
	<#assign humanoid = true>
</#if>

<#assign exmodel = data.mobModelName + "Model" + "<" + name + "Entity>">
<#assign asmodel = data.mobModelName + "Model" + "(<#if data.mobModelName == "Ocelot" || data.mobModelName == "Villager" || data.mobModelName == "Witch">0.0F<#elseif data.mobModelName == "Slime">16</#if>)">

public class ${name}Renderer extends <#if humanoid>Biped</#if>Renderer<${name}Entity, ${exmodel}> {

	public static class ModelRegisterHandler {

	public ${name}Renderer(EntityRendererManager renderManagerIn) {
		super(<#if !data.isBuiltInModel()>renderManagerIn, new ${data.mobModelName}<#else> renderManagerIn, new ${asmodel}<#if>, ${data.modelShadowSize});
		
	}

	<#if data.mobModelName == "Villager">
	@Override protected void preRenderCallback(${name}Entity entitylivingbaseIn, float partialTickTime) {
		float f = 0.9375F;
		if (entitylivingbaseIn.isChild()) {
	        	f = (float)((double)f * 0.5D);
			this.shadowSize = 0.25F;
		} else {
			this.shadowSize = 0.5F;
	      	}
		GlStateManager.scalef(f, f, f);
	}
	</#if>

	@Override public ResourceLocation getTextureLocation(${name}Entity entity) {
		return new ResourceLocation("${modid}:textures/entities/${data.mobModelTexture}");
	}

    <#if data.getModelCode()?? && !data.isBuiltInModel()>
        ${data.getModelCode().toString()
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
