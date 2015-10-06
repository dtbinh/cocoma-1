// transform some signals into beliefs (since the artifact has no observable properties, but uses signals)

+product(ProductId, Volume, BaseList)[artifact_id(_)]
	: not product(ProductId, Volume, BaseList)
<-
	+product(ProductId, Volume, BaseList);
	.	
	
+steps(Steps)[artifact_id(_)]
	: not steps(Steps)
<-	
	+steps(Steps);
	.
	
+charge(Battery)[artifact_id(_)] <- -+charge(Battery).	

+load(Load)[artifact_id(_)] <- -+load(Load).	

+inFacility(Facility)[artifact_id(_)]
<- 
	-going(Facility);
	-+inFacility(Facility);
	.
	