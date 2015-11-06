{ include("common-rules.asl") }
{ include("common-plans.asl") }
{ include("actions.asl") }





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
+role(Role, Speed, LoadCap, BatteryCap, Tools): .my_name(Self)
<-
	.print("Got role: ", Role);
	!new_round;
	.lower_case(Role, File);
	.concat(File, ".asl", FileExt);
	.include(FileExt);
	
	for(.member(T, Tools))
	{
		+add_usability(T)
	}
	
	+init_item(tool1);
	+init_item(tool2);
	+init_item(tool3);
	// etc
	
	// exemple
	+ajouter_item(tool1, 1);
	
	// Prêt !
	+ready(Self);
	.broadcast(tell, ready(Self))
.

/* 
+pricedJob(Job, Storage, A, B, C, Item_set)
<-
	// Prêt !
	+ready(Self);
	.broadcast(tell, ready(Self))
.
* 
*/


// Quand tout le monde est prêt on lance l'algo
+ready(_) : .findall(Z, ready(Z), L) & .length(L, O)
<-
	//.print(Y, " me dit qu'il est ready, nb de reçut :", O);
	if(O == 4)
	{
		.print("LAUCH");
		+compute(tool1);
		-ready(_)
	}
	
.

// Ajoute X pour un 'item' donné
+ajouter_item(Item, X) : .my_name(Self) & product(Item, A, L)
<-
	+add_to_own(product(Item, A, L), X);
	
	-ajouter_item(Item, X);
.

// Ajoute X à la quantité Q du 'product' donné
+add_to_own(Product, X): .my_name(Self) & own(Self, Product, Q)
<-
	-own(Self, Product, Q);
	+own(Self, Product, Q+X);
	
	-add_to_own(Product, X)
.

+add_usability(Item) : .my_name(Self) & product(Item, A, L)
<-
	+use(Self, product(Item, A, L));
	-add_usability(Item)
.

+init_item(Item) : .my_name(Self) & product(Item, A, L)
<-
	+own(Self, product(Item, A, L), 0);
	
	-init_item(Item);
.



// On attend que tout le monde ai envoyé ses messages
+own(Who, Item, _) : .findall(Who, own(Who, Item, _), L) & .length(L, O)
<-
	if(O == 4)
	{
		.print("JOIN");
	}
.

+compute(Item) : .my_name(Self) & product(Item, A, L)
<- 
	if(own(Self, product(Item, A, L), Q) & (Q > 0))
	{
		if(use(Self, product(Item, A, L)))
		{
			.print("1, 1");
			//.broadcast(tell, own(Self, Item, Q));
			//.broadcast(tell, use(Self, Item));
		}
		else
		{
			.print("1, 0");
			//.broadcast(tell, own(Self, Item, Q));
		}
	}
	else
	{
		if(use(Self, product(Item, A, L)))
		{
			.print("0, 1");
			//.broadcast(tell, use(Self, Item));
			//.broadcast(tell, own(Self, Item, Q));
		}
		else
		{
			.print("0, 0");
			//.broadcast(tell, own(Self, Item, Q));
		}
	}
	-compute(Item);
.


