import type { Metadata } from "next";
import Script from "next/script";
import { Inter, Libre_Baskerville, Geist_Mono } from "next/font/google";
import { ThemeProvider } from "@/components/providers/theme-provider";
import { AuthProvider } from "@/components/providers/auth-provider";
import { ConsentProvider } from "@/components/ConsentProvider";
import GoogleAnalytics from "@/components/GoogleAnalytics";
import { WebVitals } from "@/components/WebVitals";
import {
  CookieConsentBanner,
} from "@/components/CookieConsentBanner";
import { AnnouncementBar } from "@/components/layout/announcement-bar";
import { SiteHeader } from "@/components/layout/site-header";
import { SiteFooter } from "@/components/layout/site-footer";
import { WishlistSync } from "@/components/wishlist/wishlist-sync";
import { Toaster } from "@/components/ui/sonner";
import { GlobalStructuredData } from "@/components/structured-data";
import { siteDescription, siteKeywords, siteName, siteUrl } from "@/lib/seo";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
});

const baskerville = Libre_Baskerville({
  variable: "--font-jakarta",
  subsets: ["latin"],
  weight: ["400", "700"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL(siteUrl),
  title: {
    default: `${siteName} · Discover Your Next Favorite Book`,
    template: `%s · ${siteName}`,
  },
  description: siteDescription,
  applicationName: siteName,
  keywords: siteKeywords,
  authors: [{ name: siteName, url: siteUrl }],
  creator: siteName,
  publisher: siteName,
  category: "shopping",
  alternates: {
    canonical: "/",
  },
  formatDetection: {
    telephone: false,
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-image-preview": "large",
      "max-snippet": -1,
      "max-video-preview": -1,
    },
  },
  openGraph: {
    type: "website",
    locale: "en_US",
    url: siteUrl,
    siteName,
    title: `${siteName} · Discover Your Next Favorite Book`,
    description: siteDescription,
  },
  twitter: {
    card: "summary_large_image",
    title: `${siteName} · Discover Your Next Favorite Book`,
    description: siteDescription,
    creator: "@booksandyou",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning className="h-full">
      <body
        className={`${inter.variable} ${baskerville.variable} ${geistMono.variable} flex min-h-full flex-col antialiased`}
      >
        <Script id="consent-default" strategy="beforeInteractive">
          {`
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            window.gtag = window.gtag || gtag;
            gtag('consent', 'default', {
              ad_storage: 'denied',
              analytics_storage: 'denied',
              ad_user_data: 'denied',
              ad_personalization: 'denied',
              wait_for_update: 500
            });
          `}
        </Script>
        <GlobalStructuredData />
        <ThemeProvider attribute="class" defaultTheme="light" enableSystem disableTransitionOnChange>
          <ConsentProvider>
            <AuthProvider>
              <WishlistSync />
              <AnnouncementBar />
              <SiteHeader />
              <main className="flex-1">{children}</main>
              <SiteFooter />
              <Toaster richColors position="top-right" />
              <GoogleAnalytics />
              <WebVitals />
              <CookieConsentBanner />
            </AuthProvider>
          </ConsentProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
