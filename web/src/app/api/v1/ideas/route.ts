import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export const dynamic = 'force-dynamic';

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const { raw_idea, pin } = body;

    if (!raw_idea || !pin) {
      return NextResponse.json({ error: 'Missing raw_idea or pin' }, { status: 400 });
    }

    const idea_code = `IDEA-${Math.floor(1000 + Math.random() * 9000)}`;

    const newIdea = await prisma.idea.create({
      data: {
        idea_code,
        pin_code: pin, // MVP simplicity: store plain, or simple hash
        raw_idea,
        status: 'NEGOTIATING',
        doc_type: 'NONE',
      },
    });

    // Initial greeting
    await prisma.chatLog.create({
      data: {
        idea_id: newIdea.id,
        role: 'AI_ADVISOR',
        content: `Chào bạn, mình là Cố vấn ảo. Mình đã nhận được ý tưởng: "${raw_idea}". Để có hướng đánh giá chuẩn xác, ý tưởng này của bạn thuộc nhóm nào?\n1. [NEW] Tính năng mới hoàn toàn\n2. [ENHANCE] Cải tiến/Tối ưu`
      }
    });

    return NextResponse.json({
      idea_id: newIdea.id,
      idea_code: newIdea.idea_code,
      message: 'Ý tưởng đã được ghi nhận. Chuyển sang phòng Chat.'
    });

  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
