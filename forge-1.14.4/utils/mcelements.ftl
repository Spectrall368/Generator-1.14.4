<#function toResourceLocation string>
    <#if string?matches('"[^+]*"')>
        <#return "new ResourceLocation(" + string?lower_case + ")">
    <#else>
        <#return "new ResourceLocation((" + string + ").toLowerCase(java.util.Locale.ENGLISH))">
    </#if>
</#function>

<#function toAxis direction>
    <#if (direction == "Direction.EAST") || (direction == "Direction.WEST")>
        <#return "Direction.Axis.X">
    <#elseif (direction == "Direction.UP") || (direction == "Direction.DOWN")>
        <#return "Direction.Axis.Y">
    <#elseif (direction == "Direction.NORTH") || (direction == "Direction.SOUTH")>
        <#return "Direction.Axis.Z">
    <#else>
        <#return direction + ".getAxis()">
    </#if>
</#function>

<#function toBlockPos x y z>
    <#return "new BlockPos(" + opt.removeParentheses(x) + "," + opt.removeParentheses(y) + "," + opt.removeParentheses(z) +")">
</#function>
