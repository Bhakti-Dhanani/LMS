import NextAuth, { AuthOptions } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import { prisma } from "../../../../lib/prisma";
import bcrypt from "bcrypt";
import { NextApiRequest, NextApiResponse } from "next";
import { Session, DefaultSession } from "next-auth";

// Extend the Session and User interfaces
declare module "next-auth" {
  interface Session {
    user: {
      id: number; // Changed id type to number
      role: string;
    } & DefaultSession["user"];
  }

  interface User {
    id: number; // Changed id type to number
    role?: string; // Made role optional to resolve modifier conflict
  }
}

export const authOptions: AuthOptions = {
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "text" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials) {
          throw new Error("Missing credentials");
        }

        const { email, password } = credentials;
        const user = await prisma.user.findUnique({ where: { email: email || "" } });

        if (!user || !(await bcrypt.compare(password, user.password || ""))) {
          throw new Error("Invalid email or password");
        }

        return {
          id: Number(user.id),
          name: user.name,
          email: user.email,
          role: user.role || "user",
        };
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = typeof user.id === "string" ? parseInt(user.id, 10) : user.id; // Ensure id is a number
        token.role = user.role;
      }
      return token;
    },
    async session({ session, token }) {
      session.user.id = token.id as number; // Ensure id is treated as a number
      session.user.role = token.role || "user";
      return session;
    },
  },
};

export const GET = (req: NextApiRequest, res: NextApiResponse) => NextAuth(authOptions)(req, res);
export const POST = (req: NextApiRequest, res: NextApiResponse) => NextAuth(authOptions)(req, res);
