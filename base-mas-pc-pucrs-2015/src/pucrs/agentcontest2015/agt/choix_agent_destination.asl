
// ***** POUR LE CHOIX DE L'AGENT QUI VA DEPOSER L'OBJET *****	
+!choixAgent(ListeAgents, Destination) 
<-
	.random(Key);
	for(.member(Agent, ListeAgents))
	{	
		if(ag_location(Agent, Location) & Location \== none)
		{
			!enchereAgent(Key, Agent, Location, Destination);	
		}
	}
	
	.findall(cout_agent(Cout, Agent, Key), cout_agent(Cout, Agent, Key), List);
	.min(List, cout_agent(CoutBest, AgentBest, Key));
	
	+meilleurAgent(AgentBest);
	.abolish(cout_agent(_, _, Key)[source(_)]);
.


+!enchereAgent(Key, Agent, Source, Destination) :
	(shop(Source, Lon, Lat, _) | workshop(Source, Lon, Lat, _) | storage(Source, Lon, Lat, _, _, _, _) | dump(Source, Lon, Lat, _) | chargingStation(Source, Lon, Lat, _, _, _)) &
	(shop(Destination, Lon2, Lat2, _) | workshop(Destination, Lon2, Lat2, _) | storage(Destination, Lon2, Lat2, _, _, _, _) | dump(Destination, Lon2, Lat2, _) | chargingStation(Destination, Lon2, Lat2, _, _, _)) &
	role(_, Speed, _, _, _)
	
<-
	+cout_agent(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent, Key);
.







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
