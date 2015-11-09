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
+role(Role, Speed, LoadCap, BatteryCap, Tools) : .my_name(Self)
<-
      
	for(.member(T, Tools))
	{
		+use(Self, T);
	}

	
	.print("Got role: ", Role);
	!new_round;
	.lower_case(Role, File);
	.concat(File, ".asl", FileExt);
	.include(FileExt);

	// attente du chargement des spécificités du rôle
	.wait({+is_include});
	-is_include;
	
    !synchroReady;
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
			+engagement(Item, 0);
			!broadcast(Storage, Item, Quantity);
		}
	}
	
.


// Estimation du coût d'un job
+!estimerCout(pricedJobX(Job, Storage, A, B, C, Item_set))
<-
	+estimationCout(pricedJobX(Job, Storage, A, B, C, Item_set), 10);
.

