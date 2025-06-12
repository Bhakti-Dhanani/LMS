import { NextResponse } from "next/server";
import { prisma } from "../../../../lib/prisma";

export async function GET() {
  try {
    const publishedCourses = await prisma.course.findMany({
      where: { published: true },
    });

    return NextResponse.json({ courses: publishedCourses }, { status: 200 });
  } catch (error) {
    console.error("Error fetching published courses:", error);
    return NextResponse.json({ error: "Failed to fetch published courses" }, { status: 500 });
  }
}
