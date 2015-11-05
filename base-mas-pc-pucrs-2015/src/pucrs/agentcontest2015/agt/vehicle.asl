{ include("common-rules.asl") }
{ include("common-plans.asl") }
{ include("actions.asl") }

own(self, "tool1", 1).
own(self, "tool2", 0).
own(self, "tool3", 0).
own(self, "base1", 0).
own(self, "base2", 0).
own(self, "base3", 0).
own(self, "material1", 0).
own(self, "material2", 0).
own(self, "material3", 0).

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
+role(Role, Speed, LoadCap, BatteryCap, Tools): .my_name(Y)
<-
	.print("Got role: ", Role);
	!new_round;
	.lower_case(Role, File);
	.concat(File, ".asl", FileExt);
	.include(FileExt);
	
	for(.member(T, Tools)) 
	{
		+use(Y, T);
		.print("j'ajoute ",T," a ",Y)
	}
	
	
	+compute("tool1")
.

+start
<-
	.print("start")
.

+ajouter_item(Item, X) : own(Y, Item, Q) & Y==self
<-
	+own(self, Item, Q+X);
	-own(self, Item, Q);
	-ajouter_item(Item, X);
.

+retirer_item(Item, X) : own(Y, Item, Q) & Y==self
<-
	+own(self, Item, Q-X);
	-own(self, Item, Q);
	-retirer_item(Item, X);
.

+own(Who, Item, X) : 	.findall(Y, own(Y, Item, _), L) & .length(L, O)
<-
		.print(Y)
.

+compute(Item)
<- 
	if((own(Y, Item, X)) & (X > 0) & .my_name(Y))
	{
		if(use(Y, Item))
		{
			.print("1, 1");
			.broadcast(tell, own(Y, Item, X));
			.broadcast(tell, use(Y, Item));
		}
		else
		{
			.print("1, 0");
			.broadcast(tell, own(Y, Item, X));
		}
	}
	else
	{
		if(use(Y, Item))
		{
			.print("0, 1");
			.broadcast(tell, use(Y, Item));
			.broadcast(tell, own(Y, Item, X));
		}
		else
		{
			.print("0, 0");
			.broadcast(tell, own(Y, Item, X));
		}
	}
.


