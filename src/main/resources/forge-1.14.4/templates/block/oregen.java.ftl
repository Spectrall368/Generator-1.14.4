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
<#include "../mcitems.ftl">
package ${package}.world.features.ores;
<#if data.maxGenerateHeight gt 256>
	<#assign maxGenerateHeight = 256>
<#elseif data.maxGenerateHeight lt 0>
	<#assign maxGenerateHeight = 0>
<#else>
	<#assign maxGenerateHeight = data.maxGenerateHeight>
</#if>
<#if data.minGenerateHeight gt 256>
	<#assign minGenerateHeight = 256>
<#elseif data.minGenerateHeight lt 0>
	<#assign minGenerateHeight = 0>
<#else>
	<#assign minGenerateHeight = data.minGenerateHeight>
</#if>
<#if data.generationShape != "UNIFORM">
	<#assign averageHeight = (maxGenerateHeight + minGenerateHeight) / 2>
	<#assign averageHeight = averageHeight?int>
</#if>
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

public class ${name}Feature extends OreFeature {
  	private static ${name}Feature INSTANCE = null;
  	private static ConfiguredFeature<?> CONFIGURED_FEATURE = null;

	public ${name}Feature() {
		super(OreFeatureConfig::deserialize);
	}

	public static Feature<?> feature() {
		INSTANCE = new ${name}Feature();
		CONFIGURED_FEATURE = new ConfiguredFeature<>(Feature.DECORATED, new DecoratedFeatureConfig(INSTANCE, new OreFeatureConfig(OreFeatureConfig.FillerBlockType.create("${registryname}", "${registryname}", blockstate -> {
                <#assign hasDefaultTag = replaceInList(data.blocksToReplace, "minecraft:stone_ore_replaceables", "stone_ore_replaceables")?seq_contains("TAG:stone_ore_replaceables")>
                <#if hasDefaultTag>Block blockAt = blockstate.getBlock();</#if>
                return <#if hasDefaultTag>blockAt == Blocks.STONE || blockAt == Blocks.GRANITE || blockAt == Blocks.DIORITE || blockAt == Blocks.ANDESITE <#if (data.blocksToReplace?size > 1)>|| </#if></#if><#if !hasDefaultTag || (data.blocksToReplace?size > 1)>${containsAnyOfBlocks(removeFromList(removeFromList(data.blocksToReplace, "TAG:stone_ore_replaceables"), "TAG:minecraft:stone_ore_replaceables"), "blockstate")}</#if>;
			}), ${JavaModName}Blocks.${REGISTRYNAME}.get().getDefaultState(), ${data.frequencyOnChunk}), <#if data.generationShape == "UNIFORM">Placement.COUNT_RANGE<#else>Placement.COUNT_DEPTH_AVERAGE</#if>, new <#if data.generationShape == "UNIFORM">CountRangeConfig(${data.frequencyPerChunks}, ${minGenerateHeight}, 0, ${maxGenerateHeight}<#else>DepthAverageConfig(${data.frequencyPerChunks}, ${averageHeight}, ${averageHeight}</#if>)));

		return INSTANCE;
	}

	public static ConfiguredFeature<?> configuredFeature() {
	    if (CONFIGURED_FEATURE == null)
	        feature();

		return CONFIGURED_FEATURE;
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
	)
	<#else>
	null
	</#if>;

	<#if data.restrictionBiomes?has_content && cond>
	private final Set<DimensionType> generate_dimensions = ImmutableSet.of(
			<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
	        <#assign biomeName = fixNamespace(restrictionBiome)>
			<#if biomeName == "#minecraft:is_overworld">
				DimensionType.OVERWORLD
			<#elseif biomeName == "#minecraft:is_nether">
				DimensionType.THE_NETHER
			<#else>
				DimensionType.THE_END
			</#if><#sep>,
		</#list>
	);

	@Override public boolean generate(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, OreFeatureConfig config) {
		if (!generate_dimensions.contains(world.getDimension().getType()))
			return false;

		return super.generate(world, generator, random, origin, config);
	}
	</#if>
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
<#function removeFromList list value>
    <#local filteredList = []>
    <#list list as item>
        <#if item != value>
            <#local filteredList = filteredList + [item]>
        </#if>
    </#list>
    <#return filteredList>
</#function>
<#function replaceInList list oldValue newValue>
    <#local replacedList = []>
    <#list list as item>
        <#local replacedList = replacedList + [item?replace(oldValue, newValue)]>
    </#list>
    <#return replacedList>
</#function>