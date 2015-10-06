@buyTools
+!select_goal
	: inFacility(Facility) & tools([Tool|RTools]) &
	  shopsList(List) & find_shops(Tool,List,Result) & .member(Facility,Result) & not item(Tool,1)
<-
	.print("Buying tool: ",Tool);
	!buy(Tool,1);
	-item(Tool,0);
	+item(Tool,1);
	-+tools(RTools);
	.
		
@goBuyTools
+!select_goal
	: tools([Tool|_])  & shopsList(List) & not going(_) & 
	  product(Tool, Vol, BaseList) & BaseList == []
<-
	?find_shops(Tool,List,Result);
	?best_shop(Result,Shop);
	.print("Going to shop: ",Shop," to buy tool: ",Tool);
	!goto(Shop);
	.	
	
@continueGoto
+!select_goal 
	: going(Facility) 
<-
	.print("Continuing to location ",Facility); 
	!continue;
	.		

@skipAction
+!select_goal
	: true
<-
	//.print("Nothing to do at this step");
	!skip;
	.