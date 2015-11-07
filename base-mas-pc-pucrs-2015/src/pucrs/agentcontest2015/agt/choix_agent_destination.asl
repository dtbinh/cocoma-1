
// ***** POUR LE CHOIX DE L'AGENT QUI VA DEPOSER L'OBJET *****	
+!choixAgtDestination(ListeAgents, Destination) : 
	.length(ListAgents, Length) &
	Length == 1 &
	.member(Agent, ListeAgents) &
	.my_name(Self)
<-
	+meilleurAgent(Agent, 0);
.
	
+!choixAgtDestination(ListeAgents, Destination) : 
	.my_name(Self)
<-
	for(.member(Agent, ListeAgents))
	{
		if((ag_loc(Agent, Location) | ((Self == Agent) & inFacility(Location))) & not (Location==none))
		{
			!enchereAgtDestination(Agent, Location, Destination);
		}
	}
.

//CAS : SHOP
+!enchereAgtDestination(Agent, Y, Destination) :
	shop(Y, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) &
	role(_, Speed, _, _, _)
	
<-
	+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
.


+!enchereAgtDestination(Agent, Y, Destination) :
	shop(Y, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) &
	meilleurAgent(Agent2, Y) &
	role(_, Speed, _, _, _)
<-
	if(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed<Y)
	{
		-meilleurAgent(Agent2, Y);
		+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
	}
.


//CAS : STORAGE
+!enchereAgtDestination(Agent, Y, Destination) :
	storage(Y, Lon, Lat, _, _, _, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _)  &
	role(_, Speed, _, _, _)
<-
	+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
.

+!enchereAgtDestination(Agent, Y, Destination) :
	storage(Y, Lon, Lat, _, _, _, _) &
	storage(Destination, Lon2, Lat2, _) &
	meilleurAgent(Agent2, Y) &
	role(_, Speed, _, _, _)
<-
	if(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed<Y)
	{
		-meilleurAgent(Agent2, Y);
		+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
	}
.

//CAS : WORKSHOP


+!enchereAgtDestination(Agent, WorkShop, Destination) :
	workshop(WorkShop, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) &
	meilleurAgent(Agent2, BestValue) &
	role(_, Speed, _, _, _)
<-
	
	if(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed < BestValue)
	{
		.print(Agent, " > ", Agent2);
		-meilleurAgent(Agent2, BestValue);
		+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed);
	}
.

+!enchereAgtDestination(Agent, WorkShop, Destination) :
	workshop(WorkShop, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) & 
	role(_, Speed, _, _, _)
<-
	.print("start");
	+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed);
.



//CAS : DUMP
+!enchereAgtDestination(Agent, Y, Destination) :
	dump(Y, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _)  &
	role(_, Speed, _, _, _)
<-
		+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
.


+!enchereAgtDestination(Agent, Y, Destination) :
	dump(Y, Lon, Lat, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) &
	meilleurAgent(Agent2, Y) &
	role(_, Speed, _, _, _)
<-
	if(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed<Y)
	{
		-meilleurAgent(Agent2, Y);
		+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
	}
.


//CAS : CHARGING STATION
+!enchereAgtDestination(Agent, Y, Destination) :
	chargingStation(Y, Lon, Lat, _, _, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _)  &
	role(_, Speed, _, _, _)
<-
		+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
.


+!enchereAgtDestination(Agent, Y, Destination) :
	chargingStation(Y, Lon, Lat, _, _, _) &
	storage(Destination, Lon2, Lat2, _, _, _, _) &
	meilleurAgent(Agent2, Y) &
	role(_, Speed, _, _, _)
<-
	if(((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed<Y)
	{
		-meilleurAgent(Agent2, Y);
		+meilleurAgent(Agent, ((Lon2-Lon) * (Lon2-Lon) + (Lat2-Lat) * (Lat2-Lat))/Speed)
	}
.

