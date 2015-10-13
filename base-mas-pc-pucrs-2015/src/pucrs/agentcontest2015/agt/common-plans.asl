+simEnd
<-
	!end_round;
	!new_round;
.

+!new_round
<-  .print("-------------------- BEGIN OF NEW ROUND ----------------");
	.
	
+!end_round
<-
	.print("-------------------- END OF THE ROUND ----------------");
	.abolish(_[source(self)]);
	.abolish(_[source(X)]);
    .drop_all_intentions;
    .drop_all_desires;	
.


+lastActionResult(R) : R \== none & R \== successful <- .print("last action result: ",R).

+inFacility(FacilityId)
<-  .my_name(Me);
    .broadcast(achieve,update_location(Me,FacilityId));
. 

+!update_location(Ag,L)
<-   -ag_loc(Ag,_);
     +ag_loc(Ag,L);
.

+!all_at(Ags,Loc) : .count(.member(A,Ags) & ag_loc(A,Loc)) == .length(Ags).
+!all_at(Ags,Loc) 
<-  .findall(A, .member(A,Ags) & ag_loc(A,Loc),LAt);
    .difference(Ags,LAt,RAgs);
    ?step(S);
    .print("waiting ",RAgs," to arrive at ",Loc," -- step ",S);
    !skip;
    !all_at(Ags,Loc);
.


// waits for some belief, skip otherwise
+!wait_skip(B) : B.
+!wait_skip(B) <- !skip; !wait_skip(B).


+!skip_forever
<- !skip;
   !skip_forever;
.

+!buy_item(Item,Amount) : item(Item,A) & A >= Amount.
+!buy_item(Item,Amount) : step(_)
<-  ?find_shop(Item,S);
    !goto(S, fac);
    .print("ok, in ",S);
    !buy(Item,Amount);
    !buy_item(Item,Amount).
+!buy_item(Item,Amount) 
<-  .wait({+step(_)});
    !buy_item(Item,Amount).
