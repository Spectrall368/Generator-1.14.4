<#if w.hasElementsOfType("gui")>
if (${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).containerMenu instanceof ${JavaModName}Menus.MenuAccessor)
	((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).containerMenu).sendMenuStateUpdate((PlayerEntity) ${input$entity}, 2, "${field$slider}", ${input$value}, true);
</#if>