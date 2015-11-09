

+!choixAgent(ListeAgents, Destination, Motif) 
<-
	.random(Key);
	if(Motif == "livraison")
	{
		for(.member(Agent, ListeAgents))
		{	
			if(ag_location(Agent, Location) & Location \== none)
			{
				!enchereAgentLivraison(Key, Agent, Location, Destination);	
			}
		}
	}
	
	else
	{
		if(Motif == "achat")
		{
			for(.member(Agent, ListeAgents))
			{	
				if(ag_location(Agent, Location) & Location \== none)
				{
					!enchereAgentAchat(Key, Agent, Location, Destination);	
				}
			}
		}
		else
		{
			for(.member(Agent, ListeAgents))
			{	
				if(ag_location(Agent, Location) & Location \== none)
				{
					!enchereAgentCraft(Key, Agent, Location, Destination);	
				}
			}	
		}
	}
	
	.findall(cout_agent(O, Cout, Agent, Key), cout_agent(O, Cout, Agent, Key), List);
	.min(List, cout_agent(OBest, CoutBest, AgentBest, Key));
	
	+meilleurAgent(AgentBest);
	.abolish(cout_agent(_, _, Key)[source(_)]);
.


// ***** POUR LE CHOIX DE L'AGENT QUI VA LIVRER L'OBJET *****	
+!enchereAgentLivraison(Key, Agent, Source, Destination) :
	(shop(Source, Lon, Lat, _) | workshop(Source, Lon, Lat, _) | storage(Source, Lon, Lat, _, _, _, _) | dump(Source, Lon, Lat, _) | chargingStation(Source, Lon, Lat, _, _, _)) &
	(shop(Destination, Lon2, Lat2, _) | workshop(Destination, Lon2, Lat2, _) | storage(Destination, Lon2, Lat2, _, _, _, _) | dump(Destination, Lon2, Lat2, _) | chargingStation(Destination, Lon2, Lat2, _, _, _)) &
	role(_, Speed, _, _, _)
	
<-
	.count(jetonOccupation(Agent,_), O);
	+cout_agent(O, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent, Key);
.

// ***** POUR LE CHOIX DE L'AGENT QUI VA ACHETER L'OBJET *****	
+!enchereAgentAchat(Key, Agent, Source, Destination) :
	(shop(Source, Lon, Lat, _) | workshop(Source, Lon, Lat, _) | storage(Source, Lon, Lat, _, _, _, _) | dump(Source, Lon, Lat, _) | chargingStation(Source, Lon, Lat, _, _, _)) &
	(shop(Destination, Lon2, Lat2, _) | workshop(Destination, Lon2, Lat2, _) | storage(Destination, Lon2, Lat2, _, _, _, _) | dump(Destination, Lon2, Lat2, _) | chargingStation(Destination, Lon2, Lat2, _, _, _)) &
	role(_, Speed, _, _, _)
	
<-
	.count(jetonOccupation(Agent,_), O);
	.findall(Nom, shop(Nom,_,_,_), AllShop);
	for(.member(Shop, AllShop))
	{
		if((shop(Shop, Lon3, Lat3, _)))
		{
			+coutUnitaire(Agent, (((Lon3-Lon)*(Lon3-Lon)+(Lat3-Lat)*(Lat3-Lat))+((Lon3-Lon2)*(Lon3-Lon2)+(Lat3-Lat2)*(Lat3-Lat2)))*(O+1)/(2*Speed), Key);
			/*if(coutUnitaire(AgentU, Cou, Key))
			{
				.print(AgentU," pour ", Cou, Key);
			}*/
		}
	}
	.findall(coutUnitaire(Agent, X, Key), coutUnitaire(Agent, X, Key), ListCouts);
	.min(ListCouts, coutUnitaire(BestAgent, BestX, Key));
	
	+cout_agent(O, BestX, BestAgent, Key);
	.abolish(coutUnitaire(_, _, Key)[source(_)]);
.

// ***** POUR LE CHOIX DE L'AGENT QUI VA CRAFTER L'OBJET *****	
+!enchereAgentCraft(Key, Agent, Source, Destination) :
	(shop(Source, Lon, Lat, _) | workshop(Source, Lon, Lat, _) | storage(Source, Lon, Lat, _, _, _, _) | dump(Source, Lon, Lat, _) | chargingStation(Source, Lon, Lat, _, _, _)) &
	(shop(Destination, Lon2, Lat2, _) | workshop(Destination, Lon2, Lat2, _) | storage(Destination, Lon2, Lat2, _, _, _, _) | dump(Destination, Lon2, Lat2, _) | chargingStation(Destination, Lon2, Lat2, _, _, _)) &
	role(_, Speed, _, _, _)
	
<-	
	.count(jetonOccupation(Agent,_), O);
	.findall(Nom, workshop(Nom,_,_,_), AllWShop);
	for(.member(WShop, AllWShop))
	{
		if((workshop(WShop, Lon3, Lat3, _)))
		{
			+coutUnitaire(Agent, (((Lon3-Lon)*(Lon3-Lon)+(Lat3-Lat)*(Lat3-Lat))+((Lon3-Lon2)*(Lon3-Lon2)+(Lat3-Lat2)*(Lat3-Lat2)))/(2*Speed), Key);
		}
	}
	.findall(coutUnitaire(Agent, X, Key), coutUnitaire(Agent, X, Key), ListCouts);
	.min(ListCouts, coutUnitaire(BestAgent, BestX, Key));
	
	+cout_agent(O, BestX, BestAgent, Key);
	.abolish(coutUnitaire(_, _, Key)[source(_)]);
.



// ***** POUR LE CHOIX DE LA DESTINATION *****
+!choixDestination(Agent, DstList)
<-
	.random(Key);
	for(.member(Dst, DstList))
	{
		if(ag_location(Agent, AgentLocation) & AgentLocation \== none)
		{
			!enchereDestination(Key, Agent, AgentLocation, Dst);
		}
	}
	
	.findall(cout_destination(O, Cout, Location, Key), cout_destination(O, Cout, Location, Key), List);
	.min(List, cout_destination(OBest, CoutBest, LocationBest, Key));
	
	+meilleurDestination(LocationBest);
	.abolish(cout_destination(_, _, Key)[source(_)]);
.




+!enchereDestination(Key, Agent, Source, Destination) :
	(shop(Source, Lon, Lat, _) | workshop(Source, Lon, Lat, _) | storage(Source, Lon, Lat, _, _, _, _) | dump(Source, Lon, Lat, _) | chargingStation(Source, Lon, Lat, _, _, _)) &
	(shop(Destination, Lon2, Lat2, _) | workshop(Destination, Lon2, Lat2, _) | storage(Destination, Lon2, Lat2, _, _, _, _) | dump(Destination, Lon2, Lat2, _) | chargingStation(Destination, Lon2, Lat2, _, _, _)) &
	role(_, Speed, _, _, _)
	
<-
	.count(jetonOccupation(_, Destination), O);
	+cout_destination(O, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Destination, Key);
.
