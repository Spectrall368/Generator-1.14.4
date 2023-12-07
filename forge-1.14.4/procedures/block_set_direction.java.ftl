<#include "mcelements.ftl">
{
	Direction _dir = ${input$direction};
	BlockPos _pos = ${toBlockPos(input$x,input$y,input$z)};
	BlockState _bs =  world.getBlockState(_pos);
	DirectionProperty _property = (DirectionProperty) _bs.getBlock().getStateContainer().getProperty("facing");
	if (_property != null) {
		world.setBlockState(_pos, world.getBlockState(_pos).with(_property, _dir), 3);
	} else {
		world.setBlockState(_pos, world.setBlockState(_pos).with((EnumProperty<Direction.Axis>) _bs.getBlock().getStateContainer().getProperty("axis"), _dir.getAxis()), 3);
	}
}
