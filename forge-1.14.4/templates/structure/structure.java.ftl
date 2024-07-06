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
<#include "../mcitems.ftl">
package ${package}.world.structure;

import com.mojang.datafixers.util.Pair;

<#assign cond = false>
<#if data.restrictionBiomes?has_content>
	<#list data.restrictionBiomes as restrictionBiome>
		<#if restrictionBiome?contains(":is_")>
			<#assign cond = true>
			 <#break>
		</#if>
		<#break>
	</#list>
</#if>
@Mod.EventBusSubscriber public class ${name}Structure extends ScatteredStructure<NoFeatureConfig> {
	public ${name}Structure(Function<Dynamic<?>, ? extends NoFeatureConfig> configFactory) {
		super(configFactory);
	}

	public static final ${name}Structure structure = null;

	@Override public boolean place(IWorld world, ChunkGenerator<? extends GenerationSettings> generator, Random random, BlockPos pos, NoFeatureConfig config) {
				<#if data.restrictionBiomes?has_content && cond>
					DimensionType dimensionType = world.getDimension().getType();
					boolean dimensionCriteria = false;
					<#list data.restrictionBiomes as restrictionBiome>
							<#if restrictionBiome == "#minecraft:is_overworld">
								if(dimensionType == DimensionType.OVERWORLD)
									dimensionCriteria = true;
							<#elseif restrictionBiome == "#minecraft:is_nether">
								if(dimensionType == DimensionType.THE_NETHER)
									dimensionCriteria = true;
							<#elseif restrictionBiome == "#minecraft:is_end">
								if(dimensionType == DimensionType.THE_END)
									dimensionCriteria = true;
							<#else>
								if(dimensionType == DimensionType.byName(new ResourceLocation("${modid}:${restrictionBiome?keep_after("is_")}")))
									dimensionCriteria = true;
							</#if>
					</#list>

					if(!dimensionCriteria)
						return false;
				</#if>

	return super.place(world, generator, random, pos, config);
	}

   	@Override public Structure.IStartFactory getStartFactory() {
		return ${name}Structure.Start::new;
	}

   	@Override public String getStructureName() {
		return "${modid}:${registryname}";
	}

   	@Override public int getSize() {
		return 1;
	}

   	@Override protected int getBiomeFeatureDistance(ChunkGenerator<?> chunkGenerator) {
		return ${data.spacing};
	}

   	@Override protected int getBiomeFeatureSeparation(ChunkGenerator<?> chunkGenerator) {
      		return ${data.separation};
   	}

   	@Override protected int getSeedModifier() {
		return ${thelper.randompositiveint(registryname)};
	}

   	public static class Start extends StructureStart {
      		public Start(Structure<?> structure, int chunkX, int chunkZ, Biome biome, MutableBoundingBox mutableBoundingBox, int reference, long seed) {
         		super(structure, chunkX, chunkZ, biome, mutableBoundingBox, reference, seed);
      		}

      		@Override public void init(ChunkGenerator<?> generator, TemplateManager templateManager, int chunkX, int chunkZ, Biome biome) {
			BlockPos pos = new BlockPos(chunkX * 16, generator.func_222531_c(chunkX * 16, chunkZ * 16, Heightmap.Type.${data.surfaceDetectionType}), chunkZ * 16);
			${name}StructurePieces.start(templateManager, pos);
	            	this.recalculateStructureSize();
         	}
      }

	    static {
	        JigsawManager.field_214891_a.register(new JigsawPattern(
	                        new ResourceLocation("${modid}:${registryname}"),
	                        new ResourceLocation("minecraft:empty"),
	                        ImmutableList.of(
	                                new Pair<>(new SingleJigsawPiece("${modid}:${registryname}"), 1)
	                        ),
	                        JigsawPattern.PlacementBehaviour.${data.projection?upper_case}
	                )
		);

		<#list data.jigsawPools as main>
	        JigsawManager.field_214891_a.register(new JigsawPattern(
				<#if data.poolName??>
	                        new ResourceLocation("${modid}:${registryname}_${main.poolName}"),
	                        new ResourceLocation("${main.fallbackPool?has_content?then(data.fallbackPool, "minecraft:empty")}")
				<#else>
	                        new ResourceLocation("${modid}:${registryname}"),
	                        new ResourceLocation("minecraft:empty")
				</#if>,
	                        ImmutableList.of(
					new Pair<>(new SingleJigsawPiece("${modid}:${main.structure}"), ${main.weight})
				<#list data.getPoolParts() as part>
	                                , new Pair<>(new SingleJigsawPiece("${modid}:${part.structure}"), ${part.weight})
				</#list>
	                        ),
	                        JigsawPattern.PlacementBehaviour.${main.projection?upper_case}
	                )
	        );
		</#list>
	    }

	@SubscribeEvent public static void init(FMLCommonSetupEvent event) {
		for (Biome biome : ForgeRegistries.BIOMES.getValues()) {
				<#if data.restrictionBiomes?has_content && !cond>
					boolean biomeCriteria = false;
					<#list data.restrictionBiomes as restrictionBiome>
						<#if restrictionBiome.canProperlyMap()>
						if (ForgeRegistries.BIOMES.getKey(biome).equals(new ResourceLocation("${restrictionBiome}")))
							biomeCriteria = true;
						</#if>
					</#list>
					if (!biomeCriteria)
						continue;
				</#if>
	
			biome.addStructure(structure, IFeatureConfig.NO_FEATURE_CONFIG);
			biome.addFeature(GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")},
				Biome.createDecoratedFeature(structure, IFeatureConfig.NO_FEATURE_CONFIG, Placement.NOPE, IPlacementConfig.NO_PLACEMENT_CONFIG));
	   }
	}
}
<#-- @formatter:on -->
