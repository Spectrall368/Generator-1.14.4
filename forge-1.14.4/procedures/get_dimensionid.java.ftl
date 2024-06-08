<#if field$dimension=="Surface">
	0
<#elseif field$dimension=="Nether">
	-1
<#elseif field$dimension=="End">
	1
<#else>
	(DimensionType.byName(new ResourceLocation("${generator.getResourceLocationForModElement(field$dimension.replace("CUSTOM:", ""))}")).getId())
</#if>
