private static BlockState blockStateWithInt(BlockState blockState, String property, int newValue) {
	IProperty prop = blockState.getBlock().getStateContainer().getProperty(property);
	return prop instanceof IntegerProperty && prop.getAllowedValues().contains(newValue) ? blockState.with((IntegerProperty) prop, newValue) : blockState;
}