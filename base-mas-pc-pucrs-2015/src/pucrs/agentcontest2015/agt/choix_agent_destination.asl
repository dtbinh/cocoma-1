
// ***** POUR LE CHOIX DE L'AGENT QUI VA DEPOSER L'OBJET *****	
+!choixAgtDestination(ListeAgents, Destination) : 
	.length(ListAgents, Length) &
	Length == 1 &
	.member(Agent, ListeAgents) &
	.my_name(Self)
<-
	+meilleurAgent(Agent);
.
	
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

//CAS : SHOP
+!enchereAgtDestination(Agent, Y, Destination) :
	shop(Y, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) &
	role(_, Speed, _, _, _)
	
<-
	+cout_agent(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent);
.


//CAS : STORAGE
+!enchereAgtDestination(Agent, Y, Destination) :
	storage(Y, Lon, Lat, _, _, _, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _)  &
	role(_, Speed, _, _, _)
<-
	+cout_agent(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent);
.

//CAS : WORKSHOP

+!enchereAgtDestination(Agent, WorkShop, Destination) :
	workshop(WorkShop, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) & 
	role(_, Speed, _, _, _)
<-
	+cout_agent(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent);
.


//CAS : DUMP
+!enchereAgtDestination(Agent, Y, Destination) :
	dump(Y, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _)  &
	role(_, Speed, _, _, _)
<-
	+cout_agent(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent);
.




//CAS : CHARGING STATION
+!enchereAgtDestination(Agent, Y, Destination) :
	chargingStation(Y, Lon, Lat, _, _, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _)  &
	role(_, Speed, _, _, _)
<-
	+cout_agent(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed, Agent);
.

