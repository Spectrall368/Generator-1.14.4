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
package ${package}.world.features;

<#compress>
@Mod.EventBusSubscriber public class StructureFeature extends Feature<StructureFeatureConfiguration> {
	public static final DeferredRegister<Feature<?>> REGISTRY = new DeferredRegister<>(ForgeRegistries.FEATURES, ${JavaModName}.MODID);
	public static final RegistryObject<Feature<?>> STRUCTURE_FEATURE = REGISTRY.register("structure_feature", () -> new StructureFeature(StructureFeatureConfiguration::deserialize));

	public StructureFeature(Function<Dynamic<?>, ? extends StructureFeatureConfiguration> configFactory) {
    		super(configFactory);
  	}

	public boolean place(IWorld world, ChunkGenerator<? extends GenerationSettings> generator, Random rand, BlockPos pos, StructureFeatureConfiguration config) {
		Rotation rotation = config.random_rotation ? Rotation.values()[rand.nextInt(3)] : Rotation.NONE;
		Mirror mirror = config.random_mirror ? Mirror.values()[rand.nextInt(2)] : Mirror.NONE;
		BlockPos placePos = pos.add(config.offset);
		// Load the structure template
		TemplateManager structureManager = ((ServerWorld) world.getWorld()).getSaveHandler().getStructureTemplateManager();
		Template template = structureManager.getTemplateDefaulted(config.structure);
    		if (template == null)
			return false;
		PlacementSettings placeSettings = (new PlacementSettings()).setRotation(rotation).setMirror(mirror).setRandom(rand).setIgnoreEntities(false)
			.setChunk(null).addProcessor(new BlockIgnoreStructureProcessor((config.ignored_blocks.getBlock()).stream().map(Holder::get).toList()));
		template.addBlocksToWorld(world, placePos, placeSettings);
		return true;
	}
}
</#compress>
<#-- @formatter:on -->
