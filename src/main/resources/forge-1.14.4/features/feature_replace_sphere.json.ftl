<#include "mcitems.ftl">
new SphereReplaceConfig(${toStatetoFeatureState(input$targetState)}, ${input$radius}, 5, ImmutableList.of(${toStatetoFeatureState(input$newState)}))