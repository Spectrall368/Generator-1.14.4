{
	Entity _ent = ${input$entity};
	if(_ent instanceof PlayerEntity) {
		Container _current = ((PlayerEntity) _ent).openContainer;
		if(_current instanceof Supplier) {
			Object invobj = ((Supplier) _current).get();
			if(invobj instanceof Map) {
				((Slot) ((Map) invobj).get((int)(${input$slotid}))).decrStackSize((int)(${input$amount}));
				_current.detectAndSendChanges();
			}
		}
	}
}
