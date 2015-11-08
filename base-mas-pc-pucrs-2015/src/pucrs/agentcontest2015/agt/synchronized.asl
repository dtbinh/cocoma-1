// SYNCRO
// Code
// 1 : lancer job

+jeton_ready(Who, Where)
<-	
	.count(jeton_ready(P, W), NumberOfReady);
	.my_name(Self);

	.all_names(AllAgents);
	.length(AllAgents, NumberOfAgents);
	
	// Connaissance de la position initiale des autres agents
	+ag_location(Who, Where);
	
	if(NumberOfReady >= NumberOfAgents)
	{
		.print("SYNCHRONIZED, launch job");
		// Lancer un job
		.at("now +1 s", {+pricedJobX(jobX, storage1, a, b, c, [item(material2, 2)])});
		
		.abolish(jeton_ready(_, _)[source(_)]);
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
	if(NumberOfReceive >= NumberOfAgents)
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
