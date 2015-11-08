
// FONCTION DE CHOIX D'OBJECTIFS
+!repartirObjet(DestinationId, ObjetCourant, Possesseurs, Crafteurs) :
	product(ObjetCourant, _, ListCompo)	
<-
	.my_name(Self);
	
	//Si un ou plusieurs agents possedent l'objet
	if(not .empty(Possesseurs))
	{
		.print("Quelqu'un possède l'objet : ", ObjetCourant, " -> apporter");
		
		!choixAgtDestination(Possesseurs, DestinationId);//Lignes 33 - 173
		
		if(meilleurAgent(Ag))
		{
			.print(Ag, " apporte ", ObjetCourant," à ", DestinationId);
			if(Ag == Self)
			{
				//+!goto(DestinationId)
				//TODO se charger de crafter/déposer l'objet/attendre du soutien 
			}
			-meilleurAgent(Ag, Cout);
		}
		
	}
	//sinon (personne ne possède l'objet)
	else
	{
		.print("Personne ne possède l'objet : ", ObjetCourant);
		
		//L'objet ne peut pas etre decompose
		if(.empty(ListCompo))
		{
			.print("l'objet ", ObjetCourant," n'est pas composé ! -> acheter");
			//TODO encheres pour savoir qui va l'acheter
		}
		else
		{
			.print("L'objet ", ObjetCourant," est composé !");
			
			if(.empty(Crafteurs))
			{
				.print("Personne ne peut crafter : ", ObjetCourant, " -> acheter");
			}
			else
			{
				.print("quelqu'un peut crafter : ", ObjetCourant, " -> décomposer");
				
				//On recupere tous les sous objets et leur quantite necessaire
				for(.member(consumed(SousObjet, QuantiteSSObjet), ListCompo))
				{
					!broadcast(workshopDest, SousObjet, QuantiteSSObjet);
				}
				for(.member(tools(SousOutil, _), ListCompo))
				{
					!broadcast(workshopDest, SousOutil, 1);
				}
			
				/* 
				//Si l'agent est le meilleur crafteur, il part attendre dans le workshop
				//TODO agent craftant i le plus près de dst
				if(argmax(Possesseurs) == Self)
				{
					//TODO destination la plus rentable
					if(WorkshopDest == bestDestination)
					{
						!goto(WorkshopDest);
						!assemble(ObjetCourant);
						
						//Pour qu'un autre agent lui amène les pièces
						+broadcast(WorkshopDest, X, QuantiteSSObjet)
						
					}
				}			
				else
				{
					//On teste pour chaque sous objet 
					for(sousObjet(SousObjet, QuantiteSSObjet))
					{
						+broadcast(WorkshopDest, SousObjet, QuantiteSSObjet)
			
						//On retire l'objet de la liste des sous objets
						-sousObjet(SousObjet, QuantiteSSObjet);
					}
				}
				*/
			}
			
		}
		
	}
.

