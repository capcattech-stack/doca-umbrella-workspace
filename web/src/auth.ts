import NextAuth from 'next-auth';
import Google from 'next-auth/providers/google';
import { PrismaAdapter } from '@auth/prisma-adapter';
import { prisma } from '@/lib/prisma';

export const { handlers, auth, signIn, signOut } = NextAuth({
  adapter: PrismaAdapter(prisma),
  providers: [
    Google({
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    }),
  ],
  callbacks: {
    async signIn({ user }) {
      // Get comma-separated list of allowed emails from .env
      const allowedEmails = process.env.ADMIN_EMAILS?.split(',').map(e => e.trim()) || [];
      
      // If no whitelist is defined, we block everyone to be safe, 
      // or you can return true here temporarily for testing
      if (user.email && allowedEmails.includes(user.email)) {
        return true; // Allow sign in
      }
      
      return false; // Block sign in (Access Denied)
    },
    async session({ session, user }) {
      if (session.user) {
        session.user.id = user.id;
      }
      return session;
    }
  },
  pages: {
    signIn: '/admin/login',
    error: '/admin/login', // Error code passed in query string as ?error=
  }
});
