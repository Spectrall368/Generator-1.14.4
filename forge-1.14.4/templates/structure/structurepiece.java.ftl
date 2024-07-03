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
package ${package}.world.structure.piece;

public class ${name}StructurePiece extends TemplateStructurePiece {

    public static void register() {
        JigsawManager.field_214891_a.register(new JigsawPattern(new ResourceLocation("${modid}", ""), new ResourceLocation("empty"), ImmutableList.of(Pair.of(new SingleJigsawPiece("${modid}", "${registryname}"), 1)), JigsawPattern.PlacementBehaviour.${data.projection?upper_case}));
    }

  public ${name}StructurePiece(TemplateManager templateManager, BlockPos pos) {
        super(${JavaModName}StructurePieceTypes.${data.getModElement().getRegistryNameUpper()}, 0);
        this.template = templateManager.getTemplateDefaulted(new ResourceLocation("${modid}" ,"${registryname}"));
        this.templatePosition = pos;
        Random random = new Random();
        this.rotation = Rotation.values()[random.nextInt(3)];
        this.mirror = Mirror.values()[random.nextInt(2)];
        this.placeSettings = new PlacementSettings().setRotation(this.rotation).setRandom(random).setMirror(this.mirror).setIgnoreEntities(false).setChunk(null)<#if data.ignoredBlocks?has_content>.addProcessor(new BlockIgnoreStructureProcessor(ImmutableList.of(<#list data.ignoredBlocks as block>${mappedBlockToBlock(block)}<#sep>,</#list>)))</#if>;
  }
}
<#-- @formatter:on -->
