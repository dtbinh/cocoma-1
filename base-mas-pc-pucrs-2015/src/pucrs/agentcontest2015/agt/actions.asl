// Goto (option 1)
// FacilityId must be a string
+!goto(FacilityId, _) : inFacility(FacilityId).

+!goto(FacilityId, fac)
<-
	!doAction( goto(facility(FacilityId)));
	!goto(FacilityId, cont);
.

+!goto(FacilityId, cont)
<-
	!continue;
	!goto(FacilityId, cont);
.

    
// Goto (option 2)
// Lat and Lon must be floats
+!goto(Lat, Lon)
	: true
<-
	!doAction(
		goto(
			lat(Lat),
			lon(Lon)
		)
	);
	+going;
	.

// Buy
// ItemId must be a string
// Amount must be an integer
+!buy(ItemId, Amount)
	: true
<-
	!doAction(
		buy(
			item(ItemId),
			amount(Amount)
		)
	);
.

// Give
// AgentId must be a string
// ItemId must be a string
// Amount must be an integer
+!give(AgentId, ItemId, Amount)
	: true
<-
	!doAction(
		give(
			agent(AgentId),
			item(ItemId),
			amount(Amount)
		)
	);
	.

// Receive
// AgentId must be a string
// ItemId must be a string
// Amount must be an integer
+!receive
	: true
<-
	!doAction(
		receive
	);
	.

// Store
// ItemId must be a string
// Amount must be an integer
+!store(ItemId, Amount)
	: true
<-
	!doAction(
		store(
			item(ItemId),
			amount(Amount)
		)
	);
	.

// Retrieve
// ItemId must be a string
// Amount must be an integer
+!retrieve(ItemId, Amount)
	: true
<-
	!doAction(
		retrieve(
			item(ItemId),
			amount(Amount)
		)
	);
	.

// Retrieve delivered
// ItemId must be a string
// Amount must be an integer
+!retrieve_delivered(ItemId, Amount)
	: true
<-
	!doAction(
		retrieve_delivered(
			item(ItemId),
			amount(Amount)
		)
	);
	.

// Dump
// ItemId must be a string
// Amount must be an integer
+!dump(ItemId, Amount)
	: true
<-
	!doAction(
		dump(
			item(ItemId),
			amount(Amount)
		)
	);
	.

// Assemble
// ItemId must be a string
+!assemble(ItemId)
	: true
<-
	!doAction(
		assemble(
			item(ItemId)
		)
	);
	.

// Assist assemble
// AgentId must be a string
+!assist_assemble(AgentId)
	: true
<-
	!doAction(
		assist_assemble(
			assembler(AgentId)
		)
	);
	.

// Deliver job
// JobId must be a string
+!deliver_job(JobId)
	: true
<-
	!doAction(
		deliver_job(
			job(JobId)
		)
	);
	.

// Charge
// No parameters
+!charge
	: true
<-
	+charging;
	!doAction(charge);
	.

// Bid for job
// JobId must be a string
// Price must be an integer
+!bid_for_job(JobId, Price)
	: true
<-
	!doAction(
		bid_for_job(
			job(JobId),
			price(Price)
		)
	);
	.

// Post job (option 1)
// MaxPrice must be an integer
// Fine must be an integer
// ActiveSteps must be an integer
// AuctionSteps must be an integer
// StorageId must be a string
// Items must be a string "item1=item_id1 amount1=10 item2=item_id2 amount2=5 ..."
// Example: !post_job_auction(1000, 50, 1, 10, storage1, .list(item(base1,10), item(base2,20), item(base3,30)));
+!post_job_auction(MaxPrice, Fine, ActiveSteps, AuctionSteps, StorageId, Items)
  : true
<-
  !commitAction(
      post_job(
          type(auction),
          max_price(MaxPrice),
          fine(Fine),
          active_steps(ActiveSteps),
          auction_steps(AuctionSteps),
          storage(StorageId),
          Items
      )
  );
  .

// Post job (option 2)
// Price must be an integer
// ActiveSteps must be an integer
// StorageId must be a string
// Items must be a string "item1=item_id1 amount1=10 item2=item_id2 amount2=5 ..."
// Example: !post_job_priced(1000, 50, storage1, .list(item(base1,10), item(base2,20), item(base3,30)));
+!post_job_priced(Price, ActiveSteps, StorageId, Items)
  : true
<-
  !commitAction(
      post_job(
          type(priced),
          price(Price),
          active_steps(ActiveSteps),
          storage(StorageId),
          Items
      )
  );
  .

// Continue
// No parameters
+!continue
	: true
<-
	!doAction(continue);
	.

// Skip
// No parameters
+!skip
	: true
<-
	!doAction(skip);
	.

// Abort
// No parameters
+!abort
	: true
<-
	!doAction(abort);
	.
	
+!doAction(Action)
    : step(S) 
<- 
    if (Action \== skip & Action \== continue) {
	    .print("Doing ",Action, " for step ",S);    	
    }
	action(Action); // the action in the artifact
	.wait({ +step(_) }); // wait next step to continue  
.

+!doAction(Action)
    : not step(S) 
<- 
	.wait({ +step(_) }); // wait the first step to continue
	!doAction(Action)  
.
    