<#include "procedures.java.ftl">
.then(Commands.argument("arguments", StringArgumentType.greedyString()).executes(arguments -> {
	World world = arguments.getSource().getWorld().getWorld();

	double x = arguments.getSource().getPos().getX();
	double y = arguments.getSource().getPos().getY();
	double z = arguments.getSource().getPos().getZ();

	Entity entity = arguments.getSource().getEntity();
	if (entity == null && world instanceof ServerWorld)
		entity = FakePlayerFactory.getMinecraft((ServerWorld) world);

	Direction direction = Direction.DOWN;
 	if (entity != null)
		direction = entity.getHorizontalFacing();

	HashMap<String, String> cmdparams = new HashMap<>();
	int index = -1;
	for (String param : arguments.getInput().split("\\s+")) {
		if (index >= 0)
			cmdparams.put(Integer.toString(index), param);
		index++;
	}
    <@procedureToCode name=procedure dependencies=dependencies/>
    return 0;
}))
.executes(arguments -> {
	World world = arguments.getSource().getWorld().getWorld();

	double x = arguments.getSource().getPos().getX();
	double y = arguments.getSource().getPos().getY();
	double z = arguments.getSource().getPos().getZ();

	Entity entity = arguments.getSource().getEntity();
    	if (entity == null && world instanceof ServerWorld)
        	entity = FakePlayerFactory.getMinecraft((ServerWorld) world);

   	Direction direction = Direction.DOWN;
    	if (entity != null)
    		direction = entity.getHorizontalFacing();

	HashMap<String, String> cmdparams = new HashMap<>();
	int index = -1;
	for (String param : arguments.getInput().split("\\s+")) {
		if (index >= 0)
			cmdparams.put(Integer.toString(index), param);
		index++;
	}
    <@procedureToCode name=procedure dependencies=dependencies/>
	return 0;
})
