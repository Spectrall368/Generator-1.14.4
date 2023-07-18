<#include "mcelements.ftl">
(EntityTypeTags.getCollection().getOrCreate(${toResourceLocation(input$tag)}).contains(${input$entity}.getType()))
