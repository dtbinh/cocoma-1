

	for(.member(jetonOccupation(_, D), Nb))
	{
		if((D == shop1) | (D==shop2))
			{
				.print("J'achete ", Objet);
				!goto(D, Fac);
				!buy_item(Objet,Quantite);
			}
		else
		{
			if((D == workshop1) | (D == workshop2))
			{
				.print("Je crafte ", Objet);
				!goto(D, Fac);
				!assemble(Objet);
			}
			else
			{
				
				if(D == Storage)
				{
					.print("Je livre ", Objet);
					!goto(D, Fac);
    				!deliver_job(Job);
				}
				else 
				{			
					if(ag_loc(AgentAssist, D))
					{
						.print("J'assiste");
						!goto(D, Fac);
						!assist_assemble(AgentAssist);
					}
				}
			}
			
		}
	}
.

// FONCTION DE CHOIX D'OBJECTIFS
+!repartirObjet(DestinationId, ObjetCourant, Quantity_required, Possesseurs, Crafteurs) :
	product(ObjetCourant, _, ListCompo)	& engagement(ObjetCourant, Quantite_engagee) &
	.my_name(Self) &
	ag_location(Self, EndroitActuel)
<-
	.print("Localisation : ", EndroitActuel );
	//Si un ou plusieurs agents possedent l'objet
	if(not .empty(Possesseurs))
	{
		!choixAgent(Possesseurs, DestinationId, "livraison");//Lignes 33 - 173
		
		if(meilleurAgent(Ag))
		{
			+jetonOccupation(Ag, DestinationId);
			if(Ag == Self)
			{
				.print("Quelqu'un possède l'objet : ", ObjetCourant, " -> apporter");
				// permet de ne pas dire que je possède une ressource que j'alloue dejà
				-engagement(ObjetCourant, _);
				+engagement(ObjetCourant, Quantity_required + Quantite_engagee);
				.print(Ag, " apporte ", ObjetCourant," à ", DestinationId);
			}
			.abolish(meilleurAgent(_));
		}
		
	}
	//sinon (personne ne possède l'objet)
	else
	{
		//L'objet ne peut pas etre decompose
		if(.empty(ListCompo))
		{
			// TMP
			.all_names(AllAgents);
	
			!choixAgent(AllAgents, DestinationId, "achat");
			
			if(meilleurAgent(Ag))
			{
				.findall(Nom, shop(Nom,_,_,_), AllShop);
				
				!choixDestination(Ag, AllShop);
				
				if(meilleurDestination(LocationBest))
				{
					+jetonOccupation(Ag, LocationBest);
					if(Ag == Self)
					{
						
						-engagement(ObjetCourant, _);
						+engagement(ObjetCourant, Quantite_engagee);
						.print("Personne ne possède l'objet : ", ObjetCourant);
						.print(Ag, " va acheter ", ObjetCourant, " à ", LocationBest," et l'amène à ", DestinationId);
					}
					.abolish(meilleurDestination(_));
				}
				.abolish(meilleurAgent(_));
			}
			
		}
		else
		{
			
			if(.empty(Crafteurs))
			{
				// TMP
				!choixAgent(ListeAgents, DestinationId, "achat");
				
				if(meilleurAgent(Ag))
				{
					.findall(Nom, shop(Nom,_,_,_), AllShop);
					
					!choixDestination(Ag, AllShop);
				
					if(meilleurDestination(LocationBest))
					{
						+jetonOccupation(Ag, LocationBest);
						if(Ag == Self)
						{
							-engagement(ObjetCourant, _);
							+engagement(ObjetCourant, Quantite_engagee);
							.print("Personne ne peut crafter : ", ObjetCourant, " -> acheter");
							.print(Ag, " va acheter ", ObjetCourant, " à ", LocationBest, " et l'amène à", DestinationId);
						}
						.abolish(meilleurDestination(_));
					}
					.abolish(meilleurAgent(_));
				}
			}
			else
			{
				!choixAgent(Crafteurs, DestinationId, "craft");
				
				if(meilleurAgent(Ag))
				{
					.findall(Nom, workshop(Nom,_, _, _), AllWorkShop);
					
					!choixDestination(Ag, AllWorkShop);
				
					if(meilleurDestination(LocationBest))
					{
						+jetonOccupation(Ag, LocationBest);
						if(Ag == Self)
						{
							-engagement(ObjetCourant, _);
							+engagement(ObjetCourant, Quantite_engagee);
							//.print("quelqu'un peut crafter : ", ObjetCourant, " -> décomposer");
							//.print(Ag, " va crafter ", ObjetCourant, " à ", LocationBest," et l'amène à ", DestinationId);
						}
						
						//On recupere tous les sous objets et leur quantite necessaire
						for(.member(consumed(SousObjet, QuantiteSSObjet), ListCompo))
						{
							if(not engagement(SousObjet, _))
							{
								+engagement(SousObjet, 0);
							}
							!broadcast(LocationBest, SousObjet, QuantiteSSObjet);
						}
						for(.member(tools(SousOutil, _), ListCompo))
						{
							if(not engagement(SousOutil, _))
							{
								+engagement(SousOutil, 0);
							}
							!broadcast(LocationBest, SousOutil, 1);
						}
					
						.abolish(meilleurDestination(_));
					}
					.abolish(meilleurAgent(_));
				}
				
			}
		}
	}
.

