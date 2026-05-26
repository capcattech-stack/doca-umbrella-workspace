import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export const dynamic = 'force-dynamic';

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { idea_code, pin } = body;

    if (!idea_code || !pin) {
      return NextResponse.json({ error: 'Missing idea_code or pin' }, { status: 400 });
    }

    const idea = await prisma.idea.findUnique({
      where: { idea_code },
      include: {
        ChatLog: {
          orderBy: { created_at: 'asc' }
        }
      }
    });

    if (!idea || idea.pin_code !== pin) {
      return NextResponse.json({ error: 'Invalid code or pin' }, { status: 401 });
    }

    const chat_history = idea.ChatLog.map(log => ({
      role: log.role,
      content: log.content
    }));

    return NextResponse.json({
      idea_id: idea.id,
      status: idea.status,
      chat_history
    });

  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
