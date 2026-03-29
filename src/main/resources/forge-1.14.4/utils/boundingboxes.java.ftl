<#macro makeBoundingBox positiveBoxes negativeBoxes facing noOffset pitchType="floor">
	return <#if negativeBoxes?size != 0>VoxelShapes.combineAndSimplify(</#if>
	<@mergeBoxes positiveBoxes, facing, pitchType/>
	<#if negativeBoxes?size != 0>
	, <@mergeBoxes negativeBoxes, facing, pitchType/>, IBooleanFunction.ONLY_FIRST)</#if><#if !noOffset>.withOffset(offset.x, offset.y, offset.z)</#if>
</#macro>

<#macro checkPitchSupport positiveBoxes negativeBoxes facing enablePitch noOffset>
	<#if enablePitch>
		switch ((AttachFace) state.get(FACE)) {
			case FLOOR:
			    <@makeBoundingBox positiveBoxes negativeBoxes facing noOffset "floor"/>;
			case WALL:
			    <@makeBoundingBox positiveBoxes negativeBoxes facing noOffset "wall"/>;
			default:
			    <@makeBoundingBox positiveBoxes negativeBoxes facing noOffset "ceiling"/>;
		}
	<#else>
		<@makeBoundingBox positiveBoxes negativeBoxes facing noOffset/>;
	</#if>
</#macro>

<#macro boundingBoxWithRotation positiveBoxes negativeBoxes noOffset rotationMode enablePitch=false>
	<#if rotationMode == 0>
	<@makeBoundingBox positiveBoxes negativeBoxes "north" noOffset/>;
	<#else>
		<#if rotationMode != 5>
			<#assign pitch = (rotationMode == 1 || rotationMode == 3) && enablePitch>
			switch ((Direction) state.get(FACING)) {
				case NORTH:
				    <@checkPitchSupport positiveBoxes negativeBoxes "north" pitch noOffset/>
				case EAST:
				    <@checkPitchSupport positiveBoxes negativeBoxes "east" pitch noOffset/>
				case WEST:
				    <@checkPitchSupport positiveBoxes negativeBoxes "west" pitch noOffset/>
				<#if rotationMode == 2 || rotationMode == 4>
				    case UP:
				        <@makeBoundingBox positiveBoxes negativeBoxes "up" noOffset/>;
				    case DOWN:
				        <@makeBoundingBox positiveBoxes negativeBoxes "down" noOffset/>;
				</#if>
				default:
				    <@checkPitchSupport positiveBoxes negativeBoxes "south" pitch noOffset/>
			}
		<#else>
			switch ((Direction.Axis) state.get(AXIS)) {
				case X:
				    <@makeBoundingBox positiveBoxes negativeBoxes "x" noOffset/>;
				case Y:
				    <@makeBoundingBox positiveBoxes negativeBoxes "y" noOffset/>;
				default:
				    <@makeBoundingBox positiveBoxes negativeBoxes "z" noOffset/>;
			}
		</#if>
	</#if>
</#macro>

<#macro makeCuboid box facing pitchType>
	<#if facing == "south">
		<#if pitchType == "floor">
			makeCuboidShape(${min(16 - box.mx, 16 - box.Mx)}, ${min(box.my, box.My)}, ${min(16 - box.mz, 16 - box.Mz)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(box.my, box.My)}, ${max(16 - box.mz, 16 - box.Mz)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(box.mx, box.Mx)}, ${min(16 - box.my, 16 - box.My)}, ${min(16 - box.mz, 16 - box.Mz)},
			${max(box.mx, box.Mx)}, ${max(16 - box.my, 16 - box.My)}, ${max(16 - box.mz, 16 - box.Mz)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(16 - box.mx, 16 - box.Mx)}, ${min(box.mz, box.Mz)}, ${min(box.my, box.My)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(box.mz, box.Mz)}, ${max(box.my, box.My)})
		</#if>
	<#elseif facing == "east">
		<#if pitchType == "floor">
			makeCuboidShape(${min(16 - box.mz, 16 - box.Mz)}, ${min(box.my, box.My)}, ${min(box.mx, box.Mx)},
			${max(16 - box.mz, 16 - box.Mz)}, ${max(box.my, box.My)}, ${max(box.mx, box.Mx)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(16 - box.mz, 16 - box.Mz)}, ${min(16 - box.my, 16 - box.My)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(16 - box.mz, 16 - box.Mz)}, ${max(16 - box.my, 16 - box.My)}, ${max(16 - box.mx, 16 - box.Mx)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(box.my, box.My)}, ${min(box.mz, box.Mz)}, ${min(box.mx, box.Mx)},
			${max(box.my, box.My)}, ${max(box.mz, box.Mz)}, ${max(box.mx, box.Mx)})
		</#if>
	<#elseif facing == "west">
		<#if pitchType == "floor">
			makeCuboidShape(${min(box.mz, box.Mz)}, ${min(box.my, box.My)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(box.mz, box.Mz)}, ${max(box.my, box.My)}, ${max(16 - box.mx, 16 - box.Mx)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)}, ${min(box.mx, box.Mx)},
			${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)}, ${max(box.mx, box.Mx)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(16 - box.my, 16 - box.My)}, ${min(box.mz, box.Mz)}, ${min(16 - box.mx, 16 - box.Mx)},
			${max(16 - box.my, 16 - box.My)}, ${max(box.mz, box.Mz)}, ${max(16 - box.mx, 16 - box.Mx)})
		</#if>
	<#elseif facing == "up">
		makeCuboidShape(${min(box.mx, box.Mx)}, ${min(16 - box.mz, 16 - box.Mz)}, ${min(box.my, box.My)},
		${max(box.mx, box.Mx)}, ${max(16 - box.mz, 16 - box.Mz)}, ${max(box.my, box.My)})
	<#elseif facing == "down" || facing == "z">
		makeCuboidShape(${min(box.mx, box.Mx)}, ${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)},
		${max(box.mx, box.Mx)}, ${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)})
	<#elseif facing == "x">
		makeCuboidShape(${min(box.my, box.My)}, ${min(box.mz, box.Mz)}, ${min(box.mx, box.Mx)},
		${max(box.my, box.My)}, ${max(box.mz, box.Mz)}, ${max(box.mx, box.Mx)})
	<#else>
		<#if pitchType == "floor">
			makeCuboidShape(${min(box.mx, box.Mx)}, ${min(box.my, box.My)}, ${min(box.mz, box.Mz)},
			${max(box.mx, box.Mx)}, ${max(box.my, box.My)}, ${max(box.mz, box.Mz)})
		<#elseif pitchType == "ceiling">
			makeCuboidShape(${min(16 - box.mx, 16 - box.Mx)}, ${min(16 - box.my, 16 - box.My)}, ${min(box.mz, box.Mz)},
			${max(16 - box.mx, 16 - box.Mx)}, ${max(16 - box.my, 16 - box.My)}, ${max(box.mz, box.Mz)})
		<#elseif pitchType == "wall">
			makeCuboidShape(${min(box.mx, box.Mx)}, ${min(box.mz, box.Mz)}, ${min(16 - box.my, 16 - box.My)},
			${max(box.mx, box.Mx)}, ${max(box.mz, box.Mz)}, ${max(16 - box.my, 16 - box.My)})
		</#if>
	</#if>
</#macro>

<#function min(a, b)>
	<#return (a < b)?then(a, b)>
</#function>

<#function max(a, b)>
	<#return (a > b)?then(a, b)>
</#function>

<#macro mergeBoxes boxes facing pitchType>
	<#if boxes?size == 1>
		<@makeCuboid boxes.get(0) facing pitchType/>
	<#else>
	VoxelShapes.or(<#list boxes as box>
		<@makeCuboid box facing pitchType/><#sep>,</#list>)
	</#if>
</#macro>