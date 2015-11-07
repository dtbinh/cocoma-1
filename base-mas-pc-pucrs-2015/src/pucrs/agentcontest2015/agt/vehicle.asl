{ include("common-rules.asl") }
{ include("common-plans.asl") }
{ include("actions.asl") }

{ include("choix_agent_destination.asl")}
{ include("synchronized.asl")}
{ include("main_function.asl")}
{ include("broadcast.asl")}



// register this agent into the MAPC server (simulator) using a personal interface artifact
+!register_EIS(E)
<-  
    .my_name(Me);
    .concat("perso_art_",Me,AName);
    makeArtifact(AName,"pucrs.agentcontest2015.env.EISArtifact",[],AId);
    focus(AId);
    registerEISEntity(E);
. 

+!register_freeconn
<-	
    .print("Registering...");
	registerFreeconn;
.





// plan to react to the signal role/5 (from EISArtifact)
// it loads the source code for the agent's role in the simulation
+role(Role, Speed, LoadCap, BatteryCap, Tools)
<-
	.print("Got role: ", Role);
	!new_round;
	.lower_case(Role, File);
	.concat(File, ".asl", FileExt);
	.include(FileExt);
	
	.my_name(Self);
	.abolish(inFacility(_)[source(_)]);
    +inFacility(workshop1);
	
	
	+item(material2, 1);
	
	for(.member(T, Tools))
	{
		+use(Self, T);
	}

	
	// Prêt !
	+jeton_ready(Self);
	.broadcast(tell, jeton_ready(Self))
.



// réaction à la réception d'un priced job
+pricedJobX(Job, Storage, A, B, C, Item_set)
<-
	// Prêt !
	.print("JOB !!");
	!estimerCout(pricedJobX(Job, Storage, A, B, C, Item_set));
	
	if(True)
	{
		for(.member(item(Item, Quantity), Item_set))
		{
			!broadcast(Storage, Item, Quantity);
		}
	}
	
.

+item(Item, Quantity)
<-
	.my_name(Self);
	+own(Self, Item)
.



// Estimation du coût d'un job
+!estimerCout(pricedJobX(Job, Storage, A, B, C, Item_set))
<-
	+estimationCout(pricedJobX(Job, Storage, A, B, C, Item_set), 10);
.

