// specific plans for motorcycles

!run.

+!run
<-  !buy_item(tool3,1);
	!buy_item(base2,2);

    !goto(workshop1,fac);

    .print("at workshop waiting to assemble...");    
    !wait_skip( assemble_step(AS) );
    !wait_skip( step(AS) );
	!assist_assemble(a1);    

	!skip_forever;    
.