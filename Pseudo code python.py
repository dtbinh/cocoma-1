"""
Élaboration d’un algorithme décentralisé.

chaque agent reçoit le job courant = (objet, destination)
réaction : broadcast (destination, i, X, Y), i : objet, X = 0/1 (possède l’objet i) Y = 0/1 (peut crafter l’objet i)
"""

# réception, une fois que tous les messages concernant un même objet sont reçut, on appel f
def f (dst, i, P, C):  # P : agents avec X = 1, C : agents avec Y = 1, i : objet courant, dst : agent/lieux à qui/où apporter i

	i = objet courant
	dst = là ou j’apporte i si je l’ai
	P = liste des agents annonçant posséder l’objet i
	C = liste des agents annonçant pouvoir crafter l’objet i

	if len(P) > 0: # si quelqu’un déclare posséder l’objet i
		best_agent = argmax((P, dst)) # agent possédant i le plus près de dst
		if best_agent == self : 
			go(dst) # on apporte l'objet chez le client ou la personne voulant le crafter
		else:
			# ne rien faire
	else:
		all_sous_objets = décomposition(i)

		if len(all_sous_objets) == 0: # si l'objet ne peut pas être décomposé
			protocole_enchères(i) # Le gagnant est celui qui peut aller acheter l’objet i pour un coût minimum (critères ?), celui-ci s’engage à aller l’acheter et à le livrer à destination
		else :
			best_crafter = argmax((C, dst)) # agent pouvant crafter i le plus près de dst
			for sous_objets in all_sous_objets: 
				broadcast(best_cafter, sous_objets, X(sous_objets), Y(sous_objets)) # X, Y relatif au sous objet donné

