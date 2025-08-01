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
package ${package}.world.features.configurations;

public class StructureModFeatureConfiguration implements IFeatureConfig {
   public final ResourceLocation structure;
   public final boolean random_rotation;
   public final boolean random_mirror;
   public final List<BlockState> ignored_blocks;
   public final Vec3i offset;

   public StructureModFeatureConfiguration(ResourceLocation structure, boolean random_rotation, boolean random_mirror, List<BlockState> ignored_blocks, Vec3i offset) {
      this.structure = structure;
      this.random_rotation = random_rotation;
      this.random_mirror = random_mirror;
      this.ignored_blocks = ignored_blocks;
      this.offset = offset;
   }


    @Override public <T> Dynamic<T> serialize(DynamicOps<T> ops) {
        return new Dynamic<>(ops, ops.createMap(ImmutableMap.of(
            ops.createString("structure"), ops.createString(this.structure.toString()),
            ops.createString("random_rotation"), ops.createBoolean(this.random_rotation),
            ops.createString("random_mirror"), ops.createBoolean(this.random_mirror),
            ops.createString("ignored_blocks"), ops.createList(this.ignored_blocks.stream().map((ops_) -> {
             return BlockState.serialize(ops, ops_).getValue();
            })),
            ops.createString("offset"), ops.createMap(ImmutableMap.of(
                ops.createString("x"), ops.createInt(this.offset.getX()),
                ops.createString("y"), ops.createInt(this.offset.getY()),
                ops.createString("z"), ops.createInt(this.offset.getZ()))))));
    }

    public static <T> StructureModFeatureConfiguration deserialize(Dynamic<T> dynamic) {
        ResourceLocation structure = new ResourceLocation(dynamic.get("structure").asString(""));
        boolean random_rotation = dynamic.get("random_rotation").asBoolean(false);
        boolean random_mirror = dynamic.get("random_mirror").asBoolean(false);
        List<BlockState> ignored_blocks = dynamic.get("ignored_blocks").asList(BlockState::deserialize);
        Vec3i offset = new Vec3i(
            dynamic.get("offset").get("x").asInt(0),
            dynamic.get("offset").get("y").asInt(0),
            dynamic.get("offset").get("z").asInt(0)
        );
        return new StructureModFeatureConfiguration(structure, random_rotation, random_mirror, ignored_blocks, offset);
    }
}
<#-- @formatter:on -->