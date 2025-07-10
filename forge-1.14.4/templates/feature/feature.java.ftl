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
package ${package}.world.features;

<#assign configuration = generator.map(featuretype, "features", 1)>
<#assign cond = false>
<#if data.restrictionBiomes?has_content>
	<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
	    <#assign biomeName = fixNamespace(restrictionBiome)>
        <#if biomeName == "#minecraft:is_overworld" || biomeName == "#minecraft:is_nether" || biomeName == "#minecraft:is_end">
			<#assign cond = true>
			 <#break>
		</#if>
	</#list>
</#if>
<#compress>
public class ${name}Feature extends ${generator.map(featuretype, "features")} {
  	private static ${name}Feature INSTANCE = null;
  	private static ConfiguredFeature<?> CONFIGURED_FEATURE = null;

	public ${name}Feature() {
		super(${configuration}::deserialize);
	}

	public static Feature<?> feature() {
		INSTANCE = new ${name}Feature();
		CONFIGURED_FEATURE = new ConfiguredFeature<>(Feature.DECORATED, new DecoratedFeatureConfig(INSTANCE, ${configurationcode}, Placement.NOPE, IPlacementConfig.NO_PLACEMENT_CONFIG));

		return INSTANCE;
	}

	public static ConfiguredFeature<?> configuredFeature() {
	    if (CONFIGURED_FEATURE == null)
	        feature();

		return CONFIGURED_FEATURE;
	}

	@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, ${configuration} config) {
	    BlockPos placePos = pos;
	    <#if data.restrictionBiomes?has_content && cond>
		    DimensionType dimensionType = world.getDimension().getType();
			boolean dimensionCriteria = false;
			<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
	            <#assign biomeName = fixNamespace(restrictionBiome)>
				<#if biomeName == "#minecraft:is_overworld">
				    if(dimensionType == DimensionType.OVERWORLD)
					    dimensionCriteria = true;
				<#elseif biomeName == "#minecraft:is_nether">
				    if(dimensionType == DimensionType.THE_NETHER)
						dimensionCriteria = true;
				<#else>
					if(dimensionType == DimensionType.THE_END)
			    		dimensionCriteria = true;
				</#if>
	    	</#list>

			if(!dimensionCriteria)
			    return false;
	    </#if>

		<#if data.hasPlacedFeature()>
		    <#if placementcode.contains("Rarity")>
			    if(random.nextFloat() < 1.0F / (float) ${placementcode?keep_after("Rarity(")?keep_before(")")}) {
			</#if>
			<#if placementcode.contains("Count")>
			    int count = ${placementcode?keep_after("Count(")?keep_before_last("^")};
				for(int a = 0; a < count; a++) {
		    </#if>

			<#if placementcode != "">
			    ${removeStrings(placementcode)}
			</#if>

			<#if hasProcedure(data.generateCondition)>
				int x = placePos.getX();
				int y = placePos.getY();
				int z = placePos.getZ();
				if (!<@procedureOBJToConditionCode data.generateCondition/>)
					return false;
			</#if>

			return super.place(world, generator, random, placePos, config);

			<#if placementcode.contains("Count")>}</#if>
			<#if placementcode.contains("Rarity")>}</#if>
			<#if placementcode.contains("Rarity") || placementcode.contains("Count")>return false;</#if>
		<#else>
				return super.place(world, generator, random, placePos, config);
		</#if>
	}

	public static final Set<ResourceLocation> GENERATE_BIOMES =
	<#if data.restrictionBiomes?has_content && !cond>
	ImmutableSet.of(
		<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
		    <#assign expandedBiomes = expandBiomeTag(restrictionBiome)>
		    <#list expandedBiomes as expandedBiome>
			new ResourceLocation("${expandedBiome}")<#sep>,
		    </#list><#sep>,
        </#list>
	);
	<#else>
	null;
	</#if>
}</#compress>
<#-- @formatter:on -->
<#function removeStrings str>
<#assign result = str>
<#list 1..countOccurrencesOfSlash(result) as i>
<#assign result_str = "/" + result?keep_after("/")?keep_before("/") + "/">
<#assign result = result?replace(result_str, "")>
</#list>
<#return result>
</#function>
<#function countOccurrencesOfSlash input>
  <#local count = 0>
  <#list 0..(input?length - 1) as i>
    <#if input[i] == "/">
      <#assign count = count + 1>
    </#if>
  </#list>
  <#return count>
</#function>
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