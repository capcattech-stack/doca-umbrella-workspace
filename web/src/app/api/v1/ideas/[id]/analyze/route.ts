import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';
import { createInsightGraph } from '@/lib/ai/graph';
import { HumanMessage, AIMessage, BaseMessage } from '@langchain/core/messages';

export const dynamic = 'force-dynamic';

export async function POST(req: Request, { params }: { params: Promise<{ id: string }> }) {
  try {
    const { id } = await params;

    const idea = await prisma.idea.findUnique({
      where: { id },
      include: { ChatLog: { orderBy: { created_at: 'asc' } } }
    });

    if (!idea) {
      return NextResponse.json({ error: 'Idea not found' }, { status: 404 });
    }

    if (idea.status !== 'PENDING_REVIEW') {
      return NextResponse.json({ error: 'Idea is not pending review' }, { status: 400 });
    }

    const history: BaseMessage[] = idea.ChatLog.map(log => 
      log.role === 'USER' ? new HumanMessage(log.content) : new AIMessage(log.content)
    );

    // Run Background Insight Graph
    const graph = createInsightGraph();
    const result = await graph.invoke({ messages: history, insights: {} });

    const aiInsights = result.insights;

    // Save Insights to DB
    await prisma.idea.update({
      where: { id },
      data: { ai_insights: JSON.stringify(aiInsights) }
    });

    return NextResponse.json({ success: true, insights: aiInsights });

  } catch (error) {
    console.error("Analyze Error:", error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
