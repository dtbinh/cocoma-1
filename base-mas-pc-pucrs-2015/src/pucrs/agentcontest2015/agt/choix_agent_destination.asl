
// ***** POUR LE CHOIX DE L'AGENT QUI VA DEPOSER L'OBJET *****	
+!choixAgtDestination(ListeAgents, Destination) : 
	.my_name(Self)
<-
	for(.member(Agent, ListeAgents))
	{
		if(ag_location(Agent, Location) & Location \== none)
		{
			!enchereAgtDestination(Agent, Location, Destination);
		}
	}
	
	.findall(cout_agent(Cout, Agent), cout_agent(Cout, Agent), List);
	.min(List, cout_agent(CoutBest, AgentBest));
	
	+meilleurAgent(AgentBest);
	.abolish(cout_agent(_, _)[source(_)]);
.


+!enchereAgtDestination(Agent, Src, Destination) :
	(shop(Src, Lon, Lat, _) | workshop(Src, Lon, Lat, _) | storage(Src, Lon, Lat, _, _, _, _) | dump(Src, Lon, Lat, _) | chargingStation(Src, Lon, Lat, _, _, _)) &
	storage(Destination, Lon2, Lat2, _, _, _, _) &
	role(_, Speed, _, _, _)
	
<-
	+cout_agent(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent);
.

