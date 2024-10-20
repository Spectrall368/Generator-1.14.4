<#include "mcelements.ftl">
<#include "mcitems.ftl">
<#if field$nbt == "FALSE" && field$state == "FALSE">
world.setBlockState(${toBlockPos(input$x,input$y,input$z)}, ${mappedBlockToBlockStateCode(input$block)},3);
<#else>
{
	BlockPos _bp = ${toBlockPos(input$x,input$y,input$z)};
	BlockState _bs = ${mappedBlockToBlockStateCode(input$block)};

	<#if field$state == "TRUE">
	BlockState _bso = world.getBlockState(_bp);
	for(Map.Entry<IProperty<?>, Comparable<?>> entry : _bso.getValues().entrySet()) {
		IProperty _property = _bs.getBlock().getStateContainer().getProperty(entry.getKey().getName());
		if (_property != null && _bs.has(_property))
			try {
				_bs = _bs.with(_property, (Comparable) entry.getValue());
			} catch (Exception e) {}
	}
	</#if>

	<#if field$nbt == "TRUE">
	TileEntity _te = world.getTileEntity(_bp);
	CompoundNBT _bnbt = null;
	if(_te != null) {
		_bnbt = _te.write(new CompoundNBT());
		_te.remove();
	}
	</#if>

	world.setBlockState(_bp, _bs, 3);

	<#if field$nbt == "TRUE">
	if(_bnbt != null) {
		_te = world.getTileEntity(_bp);
		if(_te != null) {
			try {
				_te.read(_bnbt);
			} catch(Exception ignored) {}
		}
	}
	</#if>
}
</#if>
