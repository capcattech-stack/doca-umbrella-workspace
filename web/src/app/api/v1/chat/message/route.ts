import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { createChatGraph } from '@/lib/ai/graph';
import { HumanMessage, AIMessage, BaseMessage } from '@langchain/core/messages';

export const dynamic = 'force-dynamic';

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { idea_id, message } = body;

    if (!idea_id || !message) {
      return NextResponse.json({ error: 'Missing idea_id or message' }, { status: 400 });
    }

    const idea = await prisma.idea.findUnique({
      where: { id: idea_id },
      include: { ChatLog: { orderBy: { created_at: 'asc' } } }
    });

    if (!idea) {
      return NextResponse.json({ error: 'Idea not found' }, { status: 404 });
    }

    // Save user message
    await prisma.chatLog.create({
      data: { idea_id, role: 'USER', content: message }
    });

    // 1. Convert DB history to Langchain Messages
    const history: BaseMessage[] = idea.ChatLog.map(log => 
      log.role === 'USER' ? new HumanMessage(log.content) : new AIMessage(log.content)
    );
    history.push(new HumanMessage(message));

    // 2. Setup Streaming Response
    const encoder = new TextEncoder();
    const stream = new ReadableStream({
      async start(controller) {
        try {
          // Init Graph
          const graph = createChatGraph();
          const config = { configurable: { thread_id: idea_id } };

          const inputs = { messages: history, status: idea.status };
          
          // Invoke the ChatGraph workflow
          const result = await graph.invoke(inputs, config);
          const finalStatus = result.status;
          
          // Get the last message from Sophia
          const lastMessage = result.messages[result.messages.length - 1];
          const fullAiResponse = lastMessage.content as string;

          // Save AI Response to DB
          await prisma.chatLog.create({
            data: { idea_id, role: 'AI_ADVISOR', content: fullAiResponse }
          });

          await prisma.idea.update({
            where: { id: idea_id },
            data: { status: finalStatus }
          });

          // Stream the text back to UI
          const words = fullAiResponse.split(' ');
          for (const word of words) {
            controller.enqueue(encoder.encode(word + ' '));
            await new Promise(r => setTimeout(r, 20)); // Token delay simulation
          }
          
          // Trigger background analysis if submitted
          if (finalStatus === "PENDING_REVIEW") {
             // In a real app, this should be a job queue or detached async task.
             // For hackathon, we can fire and forget a fetch to our local API.
             fetch(`http://localhost:3000/api/v1/ideas/${idea_id}/analyze`, { method: 'POST' }).catch(console.error);
          }

          controller.close();
        } catch (e) {
          console.error("LangGraph Error:", e);
          controller.enqueue(encoder.encode("Lỗi khi kết nối với Cố vấn AI. Đảm bảo bạn đã cấu hình OPENAI_API_KEY trong .env."));
          controller.close();
        }
      }
    });

    return new Response(stream, {
      headers: { 'Content-Type': 'text/plain; charset=utf-8' }
    });

  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
