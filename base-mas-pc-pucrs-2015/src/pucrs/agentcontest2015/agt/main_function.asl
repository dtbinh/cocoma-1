


// FONCTION DE CHOIX D'OBJECTIFS
+!repartirObjet(DestinationId, ObjetCourant, Quantity_required, Possesseurs, Crafteurs) :
	product(ObjetCourant, _, ListCompo)	
<-
	.my_name(Self);
	
	//Si un ou plusieurs agents possedent l'objet
	if(not .empty(Possesseurs))
	{
		//.print("Quelqu'un possède l'objet : ", ObjetCourant, " -> apporter");
		
		!choixAgtDestination(Possesseurs, DestinationId);//Lignes 33 - 173
		
		if(meilleurAgent(Ag))
		{
			if(Ag == Self)
			{
				// permet de ne pas dire que je possède une ressource que j'alloue dejà
				+engagement(ObjetCourant, Quantity_required)
				.print(Ag, " apporte ", ObjetCourant," à ", DestinationId);
				//+!goto(DestinationId)
				//TODO se charger de crafter/déposer l'objet/attendre du soutien 
			}
			-meilleurAgent(Ag, Cout);
		}
		
	}
	//sinon (personne ne possède l'objet)
	else
	{
		//.print("Personne ne possède l'objet : ", ObjetCourant);
		
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
					.print(Ag, " va acheter ", ObjetCourant, " et l'amène à ", DestinationId);
				}
				-meilleurAgent(Ag, Cout);
			}
		}
		else
		{
			//.print("L'objet ", ObjetCourant," est composé !");
			
			if(.empty(Crafteurs))
			{
				//.print("Personne ne peut crafter : ", ObjetCourant, " -> acheter");
				// TMP
				!choixAgtDestination(ListeAgents, DestinationId);
				
				if(meilleurAgent(Ag))
				{
					if(Ag == Self)
					{
						.print(Ag, " va acheter ", ObjetCourant, " à et l'amène à", DestinationId);
					}
					-meilleurAgent(Ag, Cout);
				}
			}
			else
			{
				//.print("quelqu'un peut crafter : ", ObjetCourant, " -> décomposer");
				
				!choixAgtDestination(Crafteurs, DestinationId);
				
				if(meilleurAgent(Ag))
				{
					if(Ag == Self)
					{
						.print(Ag, " va crafter ", ObjetCourant, " à et l'amène à ", DestinationId);
					}
					
					//On recupere tous les sous objets et leur quantite necessaire
					for(.member(consumed(SousObjet, QuantiteSSObjet), ListCompo))
					{
						!broadcast(DestinationId, SousObjet, QuantiteSSObjet);
					}
					for(.member(tools(SousOutil, _), ListCompo))
					{
						!broadcast(DestinationId, SousOutil, 1);
					}
				
					-meilleurAgent(Ag, Cout);
				}
			}
		}
	}
.

