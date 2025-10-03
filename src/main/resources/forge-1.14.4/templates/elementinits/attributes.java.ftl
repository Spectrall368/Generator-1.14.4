<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

@Mod.EventBusSubscriber public class ${JavaModName}Attributes {
    <#list attributes as attribute>
    public static final IAttribute ${attribute.getModElement().getRegistryNameUpper()} = new RangedAttribute(null, "${modid}.${attribute.getModElement().getRegistryName()}", ${attribute.defaultValue}, ${attribute.minValue}, ${attribute.maxValue}).setShouldWatch(true);
    </#list>

    @SubscribeEvent public static void onEntityConstruction(EntityEvent.EntityConstructing event) {
        if (event.getEntity() instanceof LivingEntity) {
            LivingEntity entity = (LivingEntity) event.getEntity();
            <#list attributes as attribute>
                <#if attribute.addToAllEntities>
                    entity.getAttributes().registerAttribute(${attribute.getModElement().getRegistryNameUpper()});
                    entity.getAttribute(${attribute.getModElement().getRegistryNameUpper()}).setBaseValue(${attribute.getModElement().getRegistryNameUpper()}.getDefaultValue());
                <#else>
                    <#if attribute.entities?has_content>if(
                        <#list attribute.entities as entity>
                            entity.getType() == ${generator.map(entity.getUnmappedValue(), "entities", 1)}<#sep>||
                        </#list>) {
                            entity.getAttributes().registerAttribute(${attribute.getModElement().getRegistryNameUpper()});
                            entity.getAttribute(${attribute.getModElement().getRegistryNameUpper()}).setBaseValue(${attribute.getModElement().getRegistryNameUpper()}.getDefaultValue());
                        }
                    </#if>
                    <#if attribute.addToPlayers>
                        if(entity.getType() == EntityType.PLAYER) {
                            entity.getAttributes().registerAttribute(${attribute.getModElement().getRegistryNameUpper()});
                            entity.getAttribute(${attribute.getModElement().getRegistryNameUpper()}).setBaseValue(${attribute.getModElement().getRegistryNameUpper()}.getDefaultValue());
                        }
                    </#if>
                </#if>
            </#list>
        }
    }

	<#assign playerAttributes = attributes?filter(a -> a.addToPlayers || a.addToAllEntities)>
	<#if playerAttributes?size != 0>
	@SubscribeEvent public static void playerClone(PlayerEvent.Clone event) {
		PlayerEntity oldPlayer = event.getOriginal();
		PlayerEntity newPlayer = event.getEntityPlayer();
		<#list playerAttributes as attribute>
			newPlayer.getAttribute(${attribute.getModElement().getRegistryNameUpper()}).setBaseValue(oldPlayer.getAttribute(${attribute.getModElement().getRegistryNameUpper()}).getBaseValue());
		</#list>
	}
	</#if>
}
<#-- @formatter:on -->
