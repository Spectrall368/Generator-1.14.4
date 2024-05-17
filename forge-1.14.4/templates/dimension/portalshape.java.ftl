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
package ${package}.world.teleporter;

public class ${name}PortalShape ${mcc.getInnerClassBody("net.minecraft.block.NetherPortalBlock", "Size")
	.replace("Blocks.OBSIDIAN", mappedBlockToBlock(data.portalFrame)?string)
	.replace("Blocks.NETHER_PORTAL", JavaModName + "Blocks." + registryname?upper_case + "_PORTAL.get()")
	.replace("this.world.getBlockState(blockpos.down()).isPortalFrame(this.world, blockpos.down())",
		"(this.world.getBlockState(blockpos.down()).getBlock() == " + mappedBlockToBlock(data.portalFrame) + ")")
	.replace("this.world.getBlockState(framePos).isPortalFrame(this.world, framePos)",
		"(this.world.getBlockState(framePos).getBlock() == " + mappedBlockToBlock(data.portalFrame) + ")")}
<#-- @formatter:on -->
