import { NextResponse } from "next/server";
import { PRODUCTION_SITE_URL, siteUrl } from "@/lib/seo";

const EXTRA_ORIGINS = (process.env.ALLOWED_ORIGINS || "")
  .split(",")
  .map((o) => o.trim())
  .filter(Boolean);

export function allowedOrigins(): string[] {
  const origins = new Set<string>([
    siteUrl,
    PRODUCTION_SITE_URL,
    "https://www.booksandyou.shop",
    "http://localhost:3000",
    ...EXTRA_ORIGINS,
  ]);
  return [...origins];
}

export function isAllowedOrigin(origin: string | null): boolean {
  if (!origin) return false;
  return allowedOrigins().includes(origin);
}

export function corsHeaders(origin: string | null): HeadersInit {
  const headers: Record<string, string> = {
    "Access-Control-Allow-Methods": "POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    Vary: "Origin",
  };
  if (origin && isAllowedOrigin(origin)) {
    headers["Access-Control-Allow-Origin"] = origin;
    headers["Access-Control-Allow-Credentials"] = "true";
  }
  return headers;
}

export function corsPreflight(request: Request) {
  const origin = request.headers.get("origin");
  return new NextResponse(null, {
    status: 204,
    headers: corsHeaders(origin),
  });
}

export function jsonWithCors(
  request: Request,
  body: unknown,
  init?: { status?: number }
) {
  const origin = request.headers.get("origin");
  return NextResponse.json(body, {
    status: init?.status ?? 200,
    headers: corsHeaders(origin),
  });
}
