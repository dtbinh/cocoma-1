package pucrs.agentcontest2015.env;

import jason.JasonException;
import jason.NoValueException;
import jason.asSyntax.Literal;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

import cartago.AgentId;
import cartago.Artifact;
import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import eis.EILoader;
import eis.EnvironmentInterfaceStandard;
import eis.exceptions.ActException;
import eis.exceptions.AgentException;
import eis.exceptions.EntityException;
import eis.exceptions.ManagementException;
import eis.exceptions.NoEnvironmentException;
import eis.exceptions.PerceiveException;
import eis.exceptions.RelationException;
import eis.iilang.Action;
import eis.iilang.EnvironmentState;
import eis.iilang.Parameter;
import eis.iilang.Percept;

public class EISArtifact extends Artifact {

	private Logger logger = Logger.getLogger(EISArtifact.class.getName());

	private EnvironmentInterfaceStandard ei;
	private Map<String, AgentId> agentIds;
	private Map<String, String> agentToEntity;

	private boolean receiving;

	public EISArtifact() throws IOException {
		agentIds      = new ConcurrentHashMap<String, AgentId>();
		agentToEntity = new ConcurrentHashMap<String, String>();

		try {
			ei = EILoader.fromClassName("massim.eismassim.EnvironmentInterface");
			if (ei.isInitSupported())
				ei.init(new HashMap<String, Parameter>());
			if (ei.getState() != EnvironmentState.PAUSED)
				ei.pause();
			if (ei.isStartSupported())
				ei.start();
		} catch (IOException | ManagementException e) {
			e.printStackTrace();
		}
	}

	protected void init() throws IOException {
		receiving = true;
		execInternalOp("receiving");
	}

	@OPERATION
	void register() throws EntityException {
		try {
			String agent = getOpUserId().getAgentName();
			ei.registerAgent(agent);
			ei.associateEntity(agent, agent);
			agentToEntity.put(agent, agent);
			agentIds.put(agent, getOpUserId());
			logger.info("Registering: " + agent);
		} catch (AgentException e) {
			e.printStackTrace();
		} catch (RelationException e) {
			e.printStackTrace();
		}
	}

	@OPERATION
	void registerEISEntity(String entity) throws EntityException {
		try {
			String agent = getOpUserId().getAgentName();
			ei.registerAgent(agent);
			ei.associateEntity(agent, entity);
			agentToEntity.put(agent, entity);
			agentIds.put(agent, getOpUserId());
			logger.info("Registering " + agent + " to entity " + entity);
		} catch (AgentException e) {
			e.printStackTrace();
		} catch (RelationException e) {
			e.printStackTrace();
		}
	}

	@OPERATION
	void registerFreeconn() throws EntityException {
		try {
			String agent = getOpUserId().getAgentName();
			ei.registerAgent(agent);
			String entity = ei.getFreeEntities().iterator().next();
			ei.associateEntity(agent, entity);
			agentToEntity.put(agent, entity);
			agentIds.put(agent, getOpUserId());
			logger.info("Registering " + agent + " to entity " + entity);
		} catch (AgentException e) {
			e.printStackTrace();
		} catch (RelationException e) {
			e.printStackTrace();
		}
	}

	@OPERATION
	public void action(String action) throws NoValueException {
		try {
			Action a = Translator.literalToAction(action);
			String agent = getOpUserName();
			ei.performAction(agent, a, agentToEntity.get(agent));
			//logger.info("Agent "+agent+" did "+action);
		} catch (ActException e) {
			e.printStackTrace();
		}
	}

	@INTERNAL_OPERATION
	void receiving() throws JasonException {
		while (receiving) {
			//for (String agent : ei.getAgents()) {
			for (String agent: agentIds.keySet()) {
				try {
					Collection<Percept> percepts = ei.getAllPercepts(agent).get(agentToEntity.get(agent));
					for (Percept percept : filter(percepts)) {
						String name = percept.getName();
						Literal literal = Translator.perceptToLiteral(percept);
						signal(agentIds.get(agent), name, (Object[]) literal.getTermsArray());
					}
				} catch (PerceiveException | NoEnvironmentException | JasonException e) {
					e.printStackTrace();
				}
			}
			signal("stepPerceptionFinished");
			await_time(100);
		}
	}

	@OPERATION
	void stopReceiving() {
		receiving = false;
	}

	static List<String> agent_filter = Arrays.asList(new String[]{
		"charge",
//		"entity",
//		"fPosition",
		"inFacility",
		"item",
		"lastAction",
//		"lastActionParam",
//		"lastActionResult",
//		"lat",
		"load",
//		"lon",
//		"requestAction",
		"role",
		"step",
//		"route",
//		"routeLength",
//		"team",
//		"timestamp",		

		"steps",
		"jobTaken",
		"simEnd",		
		"auctionJob",		
		"pricedJob",
		"product",		
		"shop",
		"storage",
		"workshop",
		"chargingStation",
		"dump",
	});
	
	public static List<Percept> filter( Collection<Percept> perceptions ){
		List<Percept> list = new ArrayList<Percept>();
		for(Percept perception : perceptions){
			if(agent_filter.contains(perception.getName())){
				list.add(perception);
			}
		}
		return list;
	}

}