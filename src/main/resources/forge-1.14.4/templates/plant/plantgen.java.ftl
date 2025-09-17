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
package ${package}.world.features.plants;
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

public class ${name}Feature extends Feature<NoFeatureConfig> {
  	private static ${name}Feature INSTANCE = null;
  	private static ConfiguredFeature<?> CONFIGURED_FEATURE = null;

	public ${name}Feature() {
		super(NoFeatureConfig::deserialize);
	}

	public static Feature<?> feature() {
		INSTANCE = new ${name}Feature();
		CONFIGURED_FEATURE = new ConfiguredFeature<>(Feature.DECORATED, new DecoratedFeatureConfig(INSTANCE, IFeatureConfig.NO_FEATURE_CONFIG,
			<#if data.generateAtAnyHeight>
                Placement.COUNT_RANGE, new CountRangeConfig(${data.frequencyOnChunks}, 0, 0, 128)
			<#elseif data.generationType == "Grass" && data.plantType != "growapable">
		        Placement.NOISE_HEIGHTMAP_32, new NoiseDependant(-0.8, 0, ${data.frequencyOnChunks})
			<#else>
                Placement.COUNT_HEIGHTMAP_<#if data.plantType != "growapable">32<#else>DOUBLE</#if>, new FrequencyConfig(${data.frequencyOnChunks})
			</#if>));

		return INSTANCE;
	}

	public static ConfiguredFeature<?> configuredFeature() {
	    if (CONFIGURED_FEATURE == null)
	        feature();

		return CONFIGURED_FEATURE;
	}

	@Override public boolean place(IWorld world, ChunkGenerator generator, Random random, BlockPos pos, NoFeatureConfig config) {
	    <#if data.restrictionBiomes?has_content && cond>
		if (!generate_dimensions.contains(world.getDimension().getType()))
			return false;
	    </#if>

	    <#if data.plantType == "growapable">
            int generated = 0;

            for(int j = 0; j < ${data.patchSize}; ++j) {
                BlockPos blockpos = pos.add(random.nextInt(4) - random.nextInt(4), 0, random.nextInt(4) - random.nextInt(4));
                if (world.isAirBlock(blockpos)) {
                    int k = 1 + random.nextInt(random.nextInt(${data.growapableMaxHeight}) + 1);
                    k = Math.min(${data.growapableMaxHeight}, k);
                    for(int l = 0; l < k; ++l) {
                        if (${JavaModName}Blocks.${REGISTRYNAME}.get().getDefaultState().isValidPosition(world, blockpos)) {
                            world.setBlockState(blockpos.up(l), ${JavaModName}Blocks.${REGISTRYNAME}.get().getDefaultState(), 2);
                            ++generated;
                        }
                    }
                }
            }

            return generated > 0;
        <#else>
            <#if data.generationType == "Grass">
            for(BlockState blockstate = world.getBlockState(pos); (blockstate.isAir() || blockstate.isIn(BlockTags.LEAVES)) && pos.getY() > 0; blockstate = world.getBlockState(pos)) {
                pos = pos.down();
            }
            </#if>

            int i = 0;
            for (int j = 0; j < ${data.patchSize}; ++j) {
                BlockPos blockpos = pos.add(random.nextInt(8) - random.nextInt(8), random.nextInt(4) - random.nextInt(4), random.nextInt(8) - random.nextInt(8));
                if(world.isAirBlock(blockpos) &&<#if data.generationType != "Grass">
                <#if data.plantType == "double">
                blockpos.getY() < world.getWorld().getDimension().getHeight() - 2 &&
                <#else>
                blockpos.getY() < 255 &&
                </#if>
                </#if>${JavaModName}Blocks.${REGISTRYNAME}.get().getDefaultState().isValidPosition(world, blockpos)) {
                    <#if data.plantType == "double">
                    ((DoublePlantBlock) ${JavaModName}Blocks.${REGISTRYNAME}.get()).placeAt(world, blockpos
                    <#else>
                    world.setBlockState(blockpos, ${JavaModName}Blocks.${REGISTRYNAME}.get().getDefaultState()
                    </#if>, 2);
                    ++i;
                }
            }

            return i > 0;
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