This project is a base team written in JaCaMo to participate in the
Multi-agent Programming Contest 2015

https://multiagentcontest.org

It is based on the PUCRS team (see README.md)

----

Follow the steps below to run it:

- import this folder as a java project in Eclipse

- in eclipse, open src/util/StartSercer.java and execute it

- open src/util/StartTeams.java and execute

- optionally, open and run src/util/StartMonitor.java

- in the eclipse console, select the StartServer console and press ENTER to start the simulation

----

Documentation:

- scanario description: doc/scenario.pdf
- available actions and perception: doc/eismassim.pdf

To understand the JaCaMo team:

- scanario1.jcm: the agents of the project

- vehicle.asl: the main source code for the agents (see comments in the file)
- common-plans.asl: the main plans (to start deciding a what to do in a step)
- common-select-goal.asl: select the action for the current situation
