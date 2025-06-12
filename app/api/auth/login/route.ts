import { NextResponse } from "next/server";
import { prisma } from "../../../../lib/prisma";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

export async function POST(request: Request) {
  try {
    const { email, password } = await request.json();

    if (!email || !password) {
      return NextResponse.json({ error: "Missing email or password" }, { status: 400 });
    }

    const user = await prisma.user.findUnique({ where: { email } });

    if (!user) {
      return NextResponse.json({ error: "Invalid email or password" }, { status: 401 });
    }

    const isPasswordValid = await bcrypt.compare(password, user.password || "");

    if (!isPasswordValid) {
      return NextResponse.json({ error: "Invalid email or password" }, { status: 401 });
    }

    const token = jwt.sign(
      { id: Number(user.id), email: user.email, role: user.role, name: user.name },
      process.env.NEXTAUTH_SECRET || "default_secret_key",
      { expiresIn: "10h" }
    );

    return NextResponse.json({
      message: "Login successful",
      user: {
        id: user.id,
        role: user.role,
        name: user.name,
        email: user.email,
      },
      token,
    }, { status: 200 });
  } catch (error) {
    console.error("Login error:", error);
    return NextResponse.json({ error: "Failed to login" }, { status: 500 });
  }
}
