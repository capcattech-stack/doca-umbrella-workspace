import { StateGraph, START, END, MemorySaver, Annotation } from "@langchain/langgraph";
import { BaseMessage, HumanMessage, SystemMessage, AIMessage } from "@langchain/core/messages";
import { ChatOpenAI } from "@langchain/openai";
import { SYSTEM_PROMPTS } from "./prompts";

// ---------------------------------------------------------
// 1. CHAT GRAPH (Grooming Phase with Sophia)
// ---------------------------------------------------------

export const ChatState = Annotation.Root({
  messages: Annotation<BaseMessage[]>({
    reducer: (x, y) => x.concat(y),
    default: () => [],
  }),
  status: Annotation<string>({
    reducer: (x, y) => y ?? x,
    default: () => "NEGOTIATING",
  })
});

const getModel = () => new ChatOpenAI({ 
  modelName: "gpt-4o-mini", 
  temperature: 0.7 
});

const sophiaNode = async (state: typeof ChatState.State) => {
  const model = getModel();
  const prompt = new SystemMessage(SYSTEM_PROMPTS.SOPHIA);
  const response = await model.invoke([prompt, ...state.messages]);
  
  let newStatus = state.status;
  const content = response.content as string;
  
  // Status check based on output
  if (content.includes("[MOM_TEST_REQUIRED]")) newStatus = "MOM_TEST_REQUIRED";
  else if (content.includes("[SUBMITTED]")) newStatus = "PENDING_REVIEW";
  else newStatus = "NEGOTIATING";

  return { messages: [response], status: newStatus };
};

const arthurMomTestNode = async (state: typeof ChatState.State) => {
  const model = getModel();
  const prompt = new SystemMessage(SYSTEM_PROMPTS.ARTHUR_MOM_TEST);
  
  // We don't want Arthur to see himself as a user, we just pass the history
  const response = await model.invoke([prompt, ...state.messages]);
  
  // Create a SystemMessage containing Arthur's feedback
  const arthurFeedback = new SystemMessage(`[SYSTEM] Tin nhắn phản biện từ Arthur: \n${response.content}\n\nHãy truyền đạt lại những rủi ro này cho người dùng và hỏi ý kiến của họ.`);
  
  return { messages: [arthurFeedback], status: "ARTHUR_REPLIED" };
};

const routeAfterSophia = (state: typeof ChatState.State) => {
  if (state.status === "MOM_TEST_REQUIRED") return "arthur_mom_test";
  return END;
};

export const createChatGraph = () => {
  const workflow = new StateGraph(ChatState)
    .addNode("sophia", sophiaNode)
    .addNode("arthur_mom_test", arthurMomTestNode)
    
    .addEdge(START, "sophia")
    .addConditionalEdges("sophia", routeAfterSophia, {
      arthur_mom_test: "arthur_mom_test",
      [END]: END,
    })
    .addEdge("arthur_mom_test", "sophia"); // Return to Sophia after Arthur speaks

  return workflow.compile();
};

// ---------------------------------------------------------
// 2. INSIGHT GRAPH (Background Analysis Phase)
// ---------------------------------------------------------

export const InsightState = Annotation.Root({
  messages: Annotation<BaseMessage[]>({
    reducer: (x, y) => x.concat(y),
    default: () => [],
  }),
  insights: Annotation<Record<string, string>>({
    reducer: (x, y) => ({ ...x, ...y }),
    default: () => ({}),
  })
});

const arthurNode = async (state: typeof InsightState.State) => {
  const model = getModel();
  const prompt = new SystemMessage(SYSTEM_PROMPTS.ARTHUR);
  const response = await model.invoke([prompt, ...state.messages]);
  return { insights: { arthur: response.content as string } };
};

const alanNode = async (state: typeof InsightState.State) => {
  const model = getModel();
  const prompt = new SystemMessage(SYSTEM_PROMPTS.ALAN);
  const response = await model.invoke([prompt, ...state.messages]);
  return { insights: { alan: response.content as string } };
};

export const createInsightGraph = () => {
  const workflow = new StateGraph(InsightState)
    .addNode("arthur", arthurNode)
    .addNode("alan", alanNode)
    // Run in parallel without Leo
    .addEdge(START, "arthur")
    .addEdge(START, "alan")
    .addEdge("arthur", END)
    .addEdge("alan", END);

  return workflow.compile();
};
