private static IProperty getPropertyByName(BlockState state, String name) {
	for (IProperty property : state.getProperties()) {
		if (property.getName().equals(name))
			return property;
	}

	return null;
}