// SYNCRO
// Code
// 1 : lancer job

+jeton_ready(Who)
<-	
	.count(jeton_ready(P), NumberOfReady);
	.my_name(Self);

	.all_names(AllAgents);
	.length(AllAgents, NumberOfAgents);
	
	if(NumberOfReady == NumberOfAgents)
	{
		.print("SYNCHRONIZED, launch job");
		// Lancer un job
		+pricedJobX(jobX, storage1, a, b, c, [item(material2, 1)]);
		
		.abolish(jeton_ready(_)[source(_)]);
	}
		
.


// Compteur de reception de messages
+jeton_receive(_, Place, Item) 		
<-
	.my_name(Self);
	
	.count(jeton_receive(_, _, Item), NumberOfReceive);
	
	.all_names(AllAgents);
	.length(AllAgents, NumberOfAgents);
	
	// quand j'ai reçus les messages de tout le monde
	if(NumberOfReceive == NumberOfAgents)
	{
		.print("SYNCHRONIZED, launch algorithm");
		
		.findall(S1, own(S1, Item), List_owner);
 		.findall(S2, craft(S2, Item), List_crafter);
 	
		.at("now +1 s", {+!repartirObjet(Place, Item, List_owner, List_crafter)});
		
		.abolish(jeton_receive(_, _, Item)[source(_)]);
		.abolish(own(_, Item)[source(_)]);
		.abolish(craft(_, Item)[source(_)]);
	}
.
