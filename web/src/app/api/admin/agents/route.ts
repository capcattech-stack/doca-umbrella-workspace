import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

const DEFAULT_AGENTS = [
  {
    agent_id: 'sophia_product_manager',
    name: 'Sophia (Product Agent)',
    model_name: 'gpt-4o',
    system_prompt: 'You are Sophia, the Product Agent (CPO). Your job is to classify ideas and act as an Arbitrator to evaluate ROI/RICE scores.',
  },
  {
    agent_id: 'arthur_market_agent',
    name: 'Arthur (Market Agent)',
    model_name: 'gpt-4o',
    system_prompt: 'You are Arthur, the Market Agent. You use The Mom Test framework to challenge users for real evidence and penalize their confidence if they lack data.',
  },
  {
    agent_id: 'leo_data_agent',
    name: 'Leo (Data Agent)',
    model_name: 'gpt-4o',
    system_prompt: 'You are Leo, the Data Agent. You read baseline metrics to calculate Reach and summarize Mini P&L reports.',
  },
  {
    agent_id: 'alan_tech_lead',
    name: 'Alan (Tech Lead)',
    model_name: 'gpt-4o',
    system_prompt: 'You are Alan, the Tech Lead. You estimate technical difficulty, Man-days effort, and associated cost for implementing features.',
  },
  {
    agent_id: 'eve_qa_agent',
    name: 'Eve (QA Agent)',
    model_name: 'gpt-4o',
    system_prompt: 'You are Eve, the QA Agent. You automatically generate UAT Test-cases (Acceptance Criteria) from the output PRD or User Story.',
  }
];

export async function GET() {
  try {
    let agents = await prisma.agentConfig.findMany({
      orderBy: { created_at: 'asc' }
    });

    // Seed if empty
    if (agents.length === 0) {
      console.log('Seeding default agents...');
      await prisma.$transaction(
        DEFAULT_AGENTS.map(agent => prisma.agentConfig.create({ data: agent }))
      );
      agents = await prisma.agentConfig.findMany({
        orderBy: { created_at: 'asc' }
      });
    }

    return NextResponse.json(agents);
  } catch (error) {
    console.error('Failed to fetch agents:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
