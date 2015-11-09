
// Cas où je peux craft et j'ai l'item (en quantitée suffisante)
+!broadcast(Place, Item, Quantity_required) : .my_name(Self) 
										& (product(Item, _, ListCompo) & (use(Self, Tool) & .member(tools(Tool, _), ListCompo)) | (product(Item, _, ListCompo2) & not .member(tools(_, 1), ListCompo2)))
										& (item(Item, Quantity) & engagement(Item, Quantite_engagee) & (Quantity - Quantite_engagee) >= Quantity_required)
<- 
	.print(Item, " : 1, 1");
	+craft(Self, Item);
	+own(Self, Item);
	
	.broadcast(tell, craft(Self, Item));
	.broadcast(tell, own(Self, Item));

	!synchroReceive(Place, Item, Quantity_required);
.

// Cas où je peux craft
+!broadcast(Place, Item, Quantity_required) : .my_name(Self) & product(Item, _, ListCompo)
										& (product(Item, _, ListCompo) & (use(Self, Tool) & .member(tools(Tool, _), ListCompo)) | (product(Item, _, ListCompo2) & not .member(tools(_, 1), ListCompo2)))									
<- 
	.print(Item, " : 0, 1");
	+craft(Self, Item);
	
	.broadcast(tell, craft(Self, Item));
	!synchroReceive(Place, Item, Quantity_required);
.

// Cas où j'ai l'item (en quantitée suffisante)
+!broadcast(Place, Item, Quantity_required) : .my_name(Self) 
										& (item(Item, Quantity) & engagement(Item, Quantite_engagee) & (Quantity - Quantite_engagee) >= Quantity_required)
<- 
	.print(Item, " : 1, 0");
	+own(Self, Item);
	
	.broadcast(tell, own(Self, Item));
	!synchroReceive(Place, Item, Quantity_required);
.

// Cas où je ne peux ni craft ni fournir l'item en quantitée suffisante
+!broadcast(Place, Item, Quantity_required) : .my_name(Self)
<- 
	.print(Item, " : 0, 0");
	!synchroReceive(Place, Item, Quantity_required);
.
