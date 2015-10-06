{ include("common-rules.asl") }
{ include("common-actions.asl") }
{ include("common-plans.asl") }
{ include("common-select-goal.asl") }
{ include("props.asl") }      // might not be needed when we make the change to obs. prop. in Cartago


// register this agent into the MAPC server (simulator) using a personal interface artifact
+!register_EIS(E)
<-  
    .my_name(Me);
    .concat("perso_art_",Me,AName);
    makeArtifact(AName,"pucrs.agentcontest2015.env.EISArtifact",[],AId);
    focus(AId);
    registerEISEntity(E). 

+!register_freeconn
<-	
    .print("Registering...");
	registerFreeconn;
	.

// plan to react to the signal role/5 (from EISArtifact)
// it loads the source code for the agent's role in the simulation
+role(Role, Speed, LoadCap, BatteryCap, Tools)
	: not roled(_, _, _, _, _)
<-
	.print("Got role: ", Role);
	!new_round(Role, Speed, LoadCap, BatteryCap, Tools);
	pucrs.agentcontest2015.actions.tolower(Role, File);
	.concat(File, ".asl", FileExt);
	pucrs.agentcontest2015.actions.include(FileExt);
	+roled(Role, Speed, LoadCap, BatteryCap, Tools);
	.
	
+role(Role, Speed, LoadCap, BatteryCap, Tools)
	: not roled(_, _, _, _, _)
<-
	.print("Role: ", Role);
	.