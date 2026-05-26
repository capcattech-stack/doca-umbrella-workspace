import { NextResponse } from 'next/server';
import { prisma } from '@/lib/prisma';

export const dynamic = 'force-dynamic';

export async function PUT(req: Request) {
  try {
    const body = await req.json();
    const { cost_per_manday, opex_multiplier } = body;

    await prisma.adminSetting.upsert({
      where: { id: 1 },
      update: {
        ...(cost_per_manday && { cost_per_manday }),
        ...(opex_multiplier && { opex_multiplier }),
      },
      create: {
        id: 1,
        cost_per_manday: cost_per_manday || 1000000,
        opex_multiplier: opex_multiplier || 0.15,
      }
    });

    return NextResponse.json({ status: 'success' });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function GET() {
  try {
    const settings = await prisma.adminSetting.findUnique({
      where: { id: 1 }
    });
    return NextResponse.json(settings || { cost_per_manday: 1000000, opex_multiplier: 0.15 });
  } catch (error) {
    console.error(error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}
