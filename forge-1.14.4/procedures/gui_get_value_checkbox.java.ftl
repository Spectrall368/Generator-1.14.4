(new Object() {
	public boolean getValue() {
		Object checkbox = guistate.get("checkbox:${field$checkbox}");
		if (checkbox instanceof Boolean) {
			return (boolean) checkbox;
		}
		return false;
	}
}.getValue())
