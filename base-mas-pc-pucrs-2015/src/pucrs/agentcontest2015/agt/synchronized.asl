// SYNCRO
// Code
// 1 : lancer job

+!synchroReady: .my_name(Self) & ag_location(Self, CurrentLocation)
<-
	!sendToNextAgent_ready(Self, CurrentLocation);
.

+!sendToNextAgent_ready(Expediteur, Location) : .my_name(Self)
<-
	.all_names(AllAgents);
	.length(AllAgents, NumberOfAgents);
	
	.nth(CurrentIndex, AllAgents, Self);	
	.nth((CurrentIndex+1) mod NumberOfAgents, AllAgents, NextAgent);

	//.print(Expediteur, "] ",Self, " -> ", NextAgent);
	.send(NextAgent, tell, jetonReady(Expediteur, Location));
.

+jetonReady(Expediteur, Location) : .my_name(Self) & Expediteur == Self
<-
	//.print(Expediteur, "] jeton Receive1");
	.all_names(AllAgents);
	.length(AllAgents, NumberOfAgents);
	.count(jetonReady(_, _), N);
	
	if(N == NumberOfAgents)
	{
		.print("STOP");
		+pricedJobX(job, storage1, a, b, c, [item(material2, 1)]);
	}
	else
	{
		.print("TOUR");
		+pricedJobX(job, storage1, a, b, c, [item(material2, 1)]);
		//!sendToNextAgent(Expediteur, Location);
	}
	.abolish(jetonReady(_, _))
.

+jetonReady(Expediteur, Location) : ag_location(Expediteur, Location)
<-
	//.print(Expediteur, "] jeton Receive2");
	!sendToNextAgent_ready(Expediteur, Location);
.

+jetonReady(Expediteur, Location)
<-
	//.print(Expediteur, "] jeton Receive3");
	if(not ag_location(Expediteur, Location))
	{
		//.print(Expediteur, "] not exist");
		+ag_location(Expediteur, Location);
	}
	
	!sendToNextAgent_ready(Expediteur, Location);
.












+!synchroReceive(Place, Item, Quantity_required) : .my_name(Self)
<-
	+tmp(Place, Item, Quantity_required);
	!sendToNextAgent_receive(Self, Item);
.

+!sendToNextAgent_receive(Expediteur, Item) : .my_name(Self)
<-
	.all_names(AllAgents);
	.length(AllAgents, NumberOfAgents);
	
	.nth(CurrentIndex, AllAgents, Self);	
	.nth((CurrentIndex+1) mod NumberOfAgents, AllAgents, NextAgent);

	//.print(Expediteur, "] ",Self, " -> ", NextAgent);
	.send(NextAgent, tell, jetonReceive(Expediteur, Item));
.


// Compteur de reception de messages
+jetonReceive(Expediteur, Item) : .my_name(Self) & Expediteur == Self & tmp(Place, Item, Quantity_required)
<-
	// quand j'ai reçus les messages de tout le monde
	
	.print("SYNCHRONIZED, ", Item);
	
	.findall(S1, own(S1, Item), List_owner);
	.findall(S2, craft(S2, Item), List_crafter);

	.at("now +2 s", {+!repartirObjet(Place, Item, Quantity_required, List_owner, List_crafter)});

	.abolish(jetonReceive(_, Item)[source(_)]);
	.abolish(own(_, Item)[source(_)]);
	.abolish(craft(_, Item)[source(_)]);
	-tmp(_, Item, _);
	
.

+jetonReceive(Expediteur, Item)
<-
	!sendToNextAgent_receive(Expediteur, Item)
.	