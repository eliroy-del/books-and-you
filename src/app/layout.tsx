import type { Metadata } from "next";
import { Inter, Plus_Jakarta_Sans, Geist_Mono } from "next/font/google";
import { ThemeProvider } from "@/components/providers/theme-provider";
import { AuthProvider } from "@/components/providers/auth-provider";
import { AnnouncementBar } from "@/components/layout/announcement-bar";
import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";
import { WishlistSync } from "@/components/wishlist/wishlist-sync";
import { Toaster } from "@/components/ui/sonner";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

const jakarta = Plus_Jakarta_Sans({
  variable: "--font-jakarta",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: {
    default: "Books & You — Discover Your Next Favorite Book",
    template: "%s · Books & You",
  },
  description:
    "A premium digital bookstore for discovering, purchasing, and managing physical and digital books—with AI recommendations, subscriptions, and a personal library.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning className="h-full">
      <body
        className={`${inter.variable} ${jakarta.variable} ${geistMono.variable} flex min-h-full flex-col antialiased`}
      >
        <ThemeProvider attribute="class" defaultTheme="light" enableSystem disableTransitionOnChange>
          <AuthProvider>
            <WishlistSync />
            <AnnouncementBar />
            <SiteHeader />
            <main className="flex-1">{children}</main>
            <SiteFooter />
            <Toaster richColors position="top-right" />
          </AuthProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
