<#include "mcelements.ftl">
<@head>
if(!world.getWorld().isRemote()) {
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	TileEntity _tileEntity = world.getTileEntity(_bp);
	BlockState _bs = world.getBlockState(_bp);
	if(_tileEntity != null) {
</@head>
		_tileEntity.getTileData().putDouble(${input$tagName}, ${input$tagValue});
<@tail>
	}

	world.getWorld().notifyBlockUpdate(_bp, _bs, _bs, 3);
}</@tail>