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
package ${package}.client.model;

@OnlyIn(Dist.CLIENT)
${model.toString()
    .replace("public static class", "public class")
    .replace("ModelRenderer ", "RendererModel ")
    .replace("ModelRenderer(", "RendererModel(")
    .replace("private final RendererModel", "public final RendererModel")
    .replace("extends ModelBase", "extends EntityModel<Entity>")
    .replace("extends EntityModel ", "extends EntityModel<Entity>")
    .replace(" extends EntityModel<Entity>", "<T extends Entity> extends EntityModel<T>")
    .replace("GlStateManager.translate", "GlStateManager.translated")
    .replace("GlStateManager.scale", "GlStateManager.scaled")
    .replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+e\\)",
	"setRotationAngles(Entity e, float f, float f1, float f2, float f3, float f4, float f5)")
    .replaceAll("setRotationAngles\\(float[\n\r\t\\s]+f,[\n\r\t\\s]+float[\n\r\t\\s]+f1,[\n\r\t\\s]+float[\n\r\t\\s]+f2,[\n\r\t\\s]+float[\n\r\t\\s]+f3,[\n\r\t\\s]+float[\n\r\t\\s]+f4,[\n\r\t\\s]+float[\n\r\t\\s]+f5,[\n\r\t\\s]+Entity[\n\r\t\\s]+entity\\)",
	"setRotationAngles(Entity entity, float f, float f1, float f2, float f3, float f4, float f5)")
    .replaceAll("setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+e\\)", "setRotationAngles(e, f, f1, f2, f3, f4, f5)")
    .replaceAll("setRotationAngles\\(f,[\n\r\t\\s]+f1,[\n\r\t\\s]+f2,[\n\r\t\\s]+f3,[\n\r\t\\s]+f4,[\n\r\t\\s]+f5,[\n\r\t\\s]+entity\\)", "setRotationAngles(entity, f, f1, f2, f3, f4, f5)")
    .replace("setRotationAngles(float f, float f1, float f2, float f3, float f4, float f5, Entity e)", "setRotationAngles(T e, float f, float f1, float f2, float f3, float f4, float f5)")
    .replace("setRotationAngles(Entity e, float f, float f1, float f2, float f3, float f4, float f5)", "setRotationAngles(T e, float f, float f1, float f2, float f3, float f4, float f5)")
    .replace("setRotationAngles(f, f1, f2, f3, f4, f5, e)", "setRotationAngles(e, f, f1, f2, f3, f4, f5)")?keep_before_last("}")}

    <#if !model.contains("setRotationAngles")>
    @Override public void setRotationAngles(T e, float f, float f1, float f2, float f3, float f4, float f5) {}
    </#if>
}
<#-- @formatter:on -->
