+step(Step) 
	: roled(_, _, _, _, _)
<-
	.wait({ +stepPerceptionFinished });
	//.print("** Step ",Step);
 	-+lastStep(Step);
	!select_goal;
	.

+simEnd
	: roled(Role, Speed, LoadCap, BatteryCap, Tools)
<-
	!end_round;
	!new_round(Role, Speed, LoadCap, BatteryCap, Tools);
	+roled(Role, Speed, LoadCap, BatteryCap, Tools);
	.

+!end_round
	: true
<-
	.print("-------------------- END OF THE ROUND ----------------");
	.abolish(_[source(self)]);
	.abolish(_[source(X)]);
    .drop_all_intentions;
    .drop_all_desires;	
	.

+!new_round(Role, Speed, LoadCap, BatteryCap, Tools)
<-
	+chargingList([]);
	+dumpList([]);
	+storageList([]);
	+shopsList([]);
	+workshopList([]);
	+tools(Tools);
	+chargeTotal(BatteryCap);
	+loadTotal(LoadCap);
	.
	
@shopsList[atomic]
+shop(ShopId, Lat, Lng, Items)
	: shopsList(List) & not .member(shop(ShopId,_),List)
<-
	.print("-> Shop: ", ShopId, " | Items: ", Items);
	-+shopsList([shop(ShopId,Items)|List]);
	.
	
@storageList[atomic]
+storage(StorageId, Lat, Lng, Price, TotCap, UsedCap, Items)
	: storageList(List) & not .member(StorageId,List)
<-
	-+storageList([StorageId|List]);
	.	
	
@chargingList[atomic]
+chargingStation(ChargingId,Lat,Lng,Rate,Price,Slots) 
	:  chargingList(List) & not .member(ChargingId,List)
<- 
	-+chargingList([ChargingId|List]);
	.
	
@workshopList[atomic]
+workshop(WorkshopId,Lat,Lng,Price) 
	:  workshopList(List) & not .member(WorkshopId,List)
<- 
	-+workshopList([WorkshopId|List]);
	.
	
@dumpList[atomic]
+dump(DumpId,Lat,Lng,Price) 
	:  dumpList(List) & not .member(DumpId,List) 
<- 
	-+dumpList([DumpId|List]);
	.
	