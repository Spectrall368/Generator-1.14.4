(new Object(){
	public boolean getValue(){
		CheckboxButton checkbox=(CheckboxButton)guistate.get("checkbox:${field$checkbox}");
		if(checkbox!=null){
			return checkbox.func_212942_a();
		}
		return false;
	}
}.getValue())
