package util;

import jacamo.infra.JaCaMoLauncher;
import jason.JasonException;
import massim.javaagents.App;

public class StartTeams {

	public static void main(String[] args) throws JasonException {

		// starts a simple team o Java Agents
		new Thread(new Runnable() {
			@Override
			public void run() {
				// SimpleDebugStreamAgent.actionconfformat = "conf/team-b/actionconf/%1$s-%2$d";
				App.main(new String[] { "./conf/team-b/javaagentsconfig.xml" });
			}
		}) .start();
		
		System.out.println("Java agents started.");

		// starts the JaCaMo team
		JaCaMoLauncher.main(new String [] { "scenario1.jcm" } );
	}
}
