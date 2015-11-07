
// Cas ou je peux craft et j'ai l'item
+!broadcast(Place, Item, Quantity_required) : .my_name(Self) 
										& (product(Item, _, ListCompo) & (use(Self, Tool) & .member(tools(Tool, 1), ListCompo)) | (product(Item, _, ListCompo2) & not .member(tools(_, 1), ListCompo2)))
										& (item(Item, Quantity) & Quantity >= Quantity_required)
<- 
	+jeton_receive(Self, Place, Item);
	+craft(Self, Item);
	+own(Self, Item);
	.print("1, 1");
	.broadcast(tell, jeton_receive(Self, Place, Item));
	.broadcast(tell, craft(Self, Item));
	.broadcast(tell, own(Self, Item));
	
.

+!broadcast(Place, Item, Quantity_required) : .my_name(Self) & product(Item, _, ListCompo)
										& (product(Item, _, ListCompo) & (use(Self, Tool) & .member(tools(Tool, 1), ListCompo)) | (product(Item, _, ListCompo2) & not .member(tools(_, 1), ListCompo2)))									
<- 
	.print("0, 1");
	+jeton_receive(Self, Place, Item);
	+craft(Self, Item);
	.broadcast(tell, jeton_receive(Self, Place, Item));
	.broadcast(tell, craft(Self, Item));
	
.

+!broadcast(Place, Item, Quantity_required) : .my_name(Self) 
										& (item(Item, Quantity) & Quantity >= Quantity_required)
<-
	+jeton_receive(Self, Place, Item);
	+own(Self, Item);
	.print("1, 0");
	.broadcast(tell, jeton_receive(Self, Place, Item));
	.broadcast(tell, own(Self, Item));
	
.

+!broadcast(Place, Item, Quantity_required) 
<- 
	.print("0, 0");
	.my_name(Self);
	+jeton_receive(Self, Place, Item);
	.broadcast(tell, jeton_receive(Self, Place, Item));
.

/*
+!broadcast(Place, Item, Q_required) : .my_name(Self) & use(Self, Item) & own(Self, Item) & item(Item, Quantity) & Quantity >= Q_required
<- 
	.print("1, 1");
	.broadcast(tell, jeton_receive(Self, Place, Item));
	.broadcast(tell, use(Self, Item));
	.broadcast(tell, own(Self, Item))
.


+!broadcast(Place, Item, Q_required) : .my_name(Self) & use(Self, Item)
<- 
	
	.print("0, 1");
	.broadcast(tell, jeton_receive(Self, Place, Item));
	.broadcast(tell, use(Self, Item));
.

+!broadcast(Place, Item, Q_required) : .my_name(Self) & own(Self, Item) & item(Item, Quantity) & Quantity >= Q_required
<- 
	.print("1, 0");
	.broadcast(tell, jeton_receive(Self, Place, Item));
	.broadcast(tell, own(Self, Item))
.

+!broadcast(Place, Item, Q_required) 
<- 
	.print("0, 0");
	.my_name(Self);
	.broadcast(tell, jeton_receive(Self, Place, Item));
.*/