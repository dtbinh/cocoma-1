// specific plans for cars

// specific plans for motorcycles

!run.

+!run
<-  
    !buy_item(tool2,1);

    !goto(workshop1,fac);
    !all_at([vehicle2,vehicle3,vehicle4],workshop1);
    
    // set the step for assemble
    ?step(S); AS = S+3;
    .broadcast(tell,assemble_step(AS));
    !wait_skip( step(AS) );
    !assemble(material3);
    ?pricedJob(JobId,Storage,Begin,End,Reward,Items);
    !goto(Storage,fac);
    !deliver_job(JobId);
    ?step(NS);
    .print("Job delivered!!!!! at step ", NS);
      
	!skip_forever;    
.