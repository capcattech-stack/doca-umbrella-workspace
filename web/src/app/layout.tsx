import type { Metadata } from 'next';
import { Inter, Lora } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'], variable: '--font-inter' });
const lora = Lora({ subsets: ['latin'], variable: '--font-lora', style: ['normal', 'italic'] });

export const metadata: Metadata = {
  title: 'Idea Workshop | AI Cố vấn Sản phẩm',
  description: 'AI-Powered Ideation & Validation Matrix',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="vi" className={`${inter.variable} ${lora.variable}`}>
      <body className="font-sans">
        {children}
      </body>
    </html>
  );
}
