import { DefaultSession, NextAuthOptions, User } from "next-auth";
import CredentialsProvider from "next-auth/providers/credentials";
import { PrismaAdapter } from "@next-auth/prisma-adapter";
import { compare } from "bcrypt";
import { prisma } from "@/lib/prisma";

declare module "next-auth" {
  interface Session extends DefaultSession {
    user: {
      id: number;
      role: string; // Ensure role is a string
    } & DefaultSession["user"];
    expires: string;
  }

  interface User {
    role?: string;
  }
}

declare module "next-auth/jwt" {
  interface JWT {
    id?: number;
    role?: string;
    accessToken?: string;
  }
}

export const authOptions: NextAuthOptions = {
  adapter: PrismaAdapter(prisma),
  session: {
    strategy: "jwt",
  },
  pages: {
    signIn: "/auth/signin",
    signOut: "/auth/signout",
    error: "/auth/error",
  },
  providers: [
    CredentialsProvider({
      name: "Credentials",
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" },
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) {
          return null;
        }

        const user = await prisma.user.findUnique({
          where: {
            email: credentials.email,
          },
        });

        if (!user || !user.password) {
          return null;
        }

        const isPasswordValid = await compare(credentials.password, user.password);

        if (!isPasswordValid) {
          return null;
        }

        return {
          id: user.id, // Ensure id is a number
          email: user.email,
          name: user.name,
          image: user.image,
          role: user.role || "user", // Provide fallback for role
        };
      },
    }),
  ],
  callbacks: {
    async jwt({ token, user, account }) {
      if (account) {
        token.accessToken = account.access_token || "new-token-generated";
      }
      if (user) {
        token.id = typeof user.id === "string" ? parseInt(user.id, 10) : user.id; // Cast id to number
        token.role = user.role || "user"; // Provide fallback for role
      }
      return token;
    },
    async session({ session, token }) {
      if (session.user) {
        session.user.id = token.id as number;
        session.user.role = token.role || "user"; // Provide fallback for role
      }
      return session;
    },
    async signIn({ user, account, profile }) {
      const token = account?.access_token || "";
      return true;
    },
  },
};