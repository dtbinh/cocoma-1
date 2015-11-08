
// Cas ou je peux craft et j'ai l'item
+!broadcast(Place, Item, Quantity_required) : .my_name(Self) 
										& (product(Item, _, ListCompo) & (use(Self, Tool) & .member(tools(Tool, 1), ListCompo)) | (product(Item, _, ListCompo2) & not .member(tools(_, 1), ListCompo2)))
										& (item(Item, Quantity) & Quantity >= Quantity_required)
<- 
	+jeton_receive(Self, Place, Item, Quantity_required);
	+craft(Self, Item);
	+own(Self, Item);
	.print(Item, " : 1, 1");
	.broadcast(tell, jeton_receive(Self, Place, Item, Quantity_required));
	.broadcast(tell, craft(Self, Item));
	.broadcast(tell, own(Self, Item));
	
.

+!broadcast(Place, Item, Quantity_required) : .my_name(Self) & product(Item, _, ListCompo)
										& (product(Item, _, ListCompo) & (use(Self, Tool) & .member(tools(Tool, 1), ListCompo)) | (product(Item, _, ListCompo2) & not .member(tools(_, 1), ListCompo2)))									
<- 
	.print(Item, " : 0, 1");
	+jeton_receive(Self, Place, Item, Quantity_required);
	+craft(Self, Item);
	.broadcast(tell, jeton_receive(Self, Place, Item, Quantity_required));
	.broadcast(tell, craft(Self, Item));
	
.

+!broadcast(Place, Item, Quantity_required) : .my_name(Self) 
										& (item(Item, Quantity) & Quantity >= Quantity_required)
<-
	+jeton_receive(Self, Place, Item, Quantity_required);
	+own(Self, Item);
	.print(Item, " : 1, 0");
	.broadcast(tell, jeton_receive(Self, Place, Item, Quantity_required));
	.broadcast(tell, own(Self, Item));
.

+!broadcast(Place, Item, Quantity_required) : .my_name(Self)
<- 
	.print(Item, " : 0, 0");
	+jeton_receive(Self, Place, Item, Quantity_required);
	.broadcast(tell, jeton_receive(Self, Place, Item, Quantity_required));
.
