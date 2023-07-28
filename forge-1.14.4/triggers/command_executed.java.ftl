@SubscribeEvent public void onCommand(CommandEvent event){
		Entity entity = event.getParseResults().getContext().getSource().getEntity();
		if(entity != null){
		double i=entity.getPosition().getX();
		double j=entity.getPosition().getY();
		double k=entity.getPosition().getZ();
		    CommandContext<CommandSource> ctx = event.getParseResults().getContext().build(event.getParseResults().getReader().getString());
		Map<String, Object> dependencies = new HashMap<>();
		dependencies.put("x" ,i);
		dependencies.put("y" ,j);
		dependencies.put("z" ,k);
		dependencies.put("world" ,entity.world);
		dependencies.put("entity" ,entity);
			dependencies.put("command",event.getParseResults().getReader().getString());
		    dependencies.put("arguments", ctx);
		dependencies.put("event",event);
		this.executeProcedure(dependencies);
		}
		}
