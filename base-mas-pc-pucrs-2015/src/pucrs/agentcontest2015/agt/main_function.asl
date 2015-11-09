


// FONCTION DE CHOIX D'OBJECTIFS
+!repartirObjet(DestinationId, ObjetCourant, Quantity_required, Possesseurs, Crafteurs) :
	product(ObjetCourant, _, ListCompo)	& engagement(ObjetCourant, Quantite_engagee)
<-
	.my_name(Self);
	
	//Si un ou plusieurs agents possedent l'objet
	if(not .empty(Possesseurs))
	{
		!choixAgtDestination(Possesseurs, DestinationId);//Lignes 33 - 173
		
		if(meilleurAgent(Ag))
		{
			if(Ag == Self)
			{
				.print("Quelqu'un possède l'objet : ", ObjetCourant, " -> apporter");
				// permet de ne pas dire que je possède une ressource que j'alloue dejà
				-engagement(ObjetCourant, _);
				+engagement(ObjetCourant, Quantity_required + Quantite_engagee);
				.print(Ag, " apporte ", ObjetCourant," à ", DestinationId);
				//+!goto(DestinationId)
				//TODO se charger de crafter/déposer l'objet/attendre du soutien 
			}
			.abolish(meilleurAgent(_, _));
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
	
			!choixAgtDestination(AllAgents, DestinationId);
			
			if(meilleurAgent(Ag))
			{
				if(Ag == Self)
				{
					.print("Personne ne possède l'objet : ", ObjetCourant);
					.print(Ag, " va acheter ", ObjetCourant, " et l'amène à ", DestinationId);
				}
				.abolish(meilleurAgent(_, _));
			}
			
		}
		else
		{
			//.print("L'objet ", ObjetCourant," est composé !");
			
			if(.empty(Crafteurs))
			{
				// TMP
				!choixAgtDestination(ListeAgents, DestinationId);
				
				if(meilleurAgent(Ag))
				{
					if(Ag == Self)
					{
						.print("Personne ne peut crafter : ", ObjetCourant, " -> acheter");
						.print(Ag, " va acheter ", ObjetCourant, " et l'amène à", DestinationId);
					}
					.abolish(meilleurAgent(_, _));
				}
			}
			else
			{

				!choixAgtDestination(Crafteurs, DestinationId);
				
				if(meilleurAgent(Ag))
				{
					if(Ag == Self)
					{
						.print("quelqu'un peut crafter : ", ObjetCourant, " -> décomposer");
						.print(Ag, " va crafter ", ObjetCourant, " à et l'amène à ", DestinationId);
					}
					
					//On recupere tous les sous objets et leur quantite necessaire
					for(.member(consumed(SousObjet, QuantiteSSObjet), ListCompo))
					{
						+engagement(SousObjet, 0);
						!broadcast(DestinationId, SousObjet, QuantiteSSObjet);
					}
					for(.member(tools(SousOutil, _), ListCompo))
					{
						+engagement(SousOutil, 0);
						!broadcast(DestinationId, SousOutil, 1);
					}
				
					.abolish(meilleurAgent(_, _));
				}
				
			}
		}
	}
.

