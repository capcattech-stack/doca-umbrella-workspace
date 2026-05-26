import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export async function PUT(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const body = await request.json();
    
    // In MVP v0, we store the API key as plain text (as agreed for speed),
    // but the field is named api_key_encrypted to prepare for future.
    const { model_name, api_key_encrypted, system_prompt } = body;

    const updatedAgent = await prisma.agentConfig.update({
      where: { id },
      data: {
        model_name,
        api_key_encrypted,
        system_prompt,
      },
    });

    return NextResponse.json(updatedAgent);
  } catch (error) {
    console.error('Failed to update agent:', error);
    return NextResponse.json({ error: 'Failed to update agent' }, { status: 500 });
  }
}
