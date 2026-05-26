import { NextResponse } from 'next/server';
import { writeFile } from 'fs/promises';
import { join } from 'path';

export async function POST(request: Request) {
  try {
    const formData = await request.formData();
    const file = formData.get('file') as File | null;
    const ideaId = formData.get('idea_id') as string | null; // Optional, might be uploaded before idea is created

    if (!file) {
      return NextResponse.json({ error: 'No file provided' }, { status: 400 });
    }

    const bytes = await file.arrayBuffer();
    const buffer = Buffer.from(bytes);

    // Generate unique filename to avoid collisions
    const safeName = file.name.replace(/[^a-zA-Z0-9.-]/g, '_');
    const filename = `${Date.now()}-${safeName}`;
    const filepath = join(process.cwd(), 'public', 'uploads', filename);
    
    await writeFile(filepath, buffer);

    const fileUrl = `/uploads/${filename}`;

    // Determine basic type for our database
    const fileType = file.type.startsWith('image/') ? 'IMAGE' : 'DOCUMENT';

    return NextResponse.json({ 
      success: true, 
      url: fileUrl, 
      filename: safeName, 
      type: fileType 
    });
  } catch (error) {
    console.error('Error uploading file:', error);
    return NextResponse.json({ error: 'Failed to upload file' }, { status: 500 });
  }
}
