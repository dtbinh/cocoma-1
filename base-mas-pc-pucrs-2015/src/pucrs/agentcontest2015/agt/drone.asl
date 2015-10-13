// specific plans for drones

!run.

+!run
<-  !buy_item(tool1,1);
    !buy_item(base1,5);
    !goto(workshop1,fac);
    !assemble(material1);
    
    !buy_item(base1,5);
    !goto(workshop1,fac);
    !assemble(material1);
    
    .print("ok, I have material 1");
    
    .print("at workshop waiting to assemble...");    
    !wait_skip( assemble_step(AS) );
    !wait_skip( step(AS) );
	!assist_assemble(a1);
	
	!skip_forever;    
.
   