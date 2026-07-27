import Link from "next/link";
import {
  Bell,
  BookMarked,
  Gift,
  MapPin,
  Package,
  Settings,
  Sparkles,
  Trophy,
  Wallet,
} from "lucide-react";
import { BookCover } from "@/components/books/book-cover";
import { Button } from "@/components/ui/button";
import { Progress } from "@/components/ui/progress";
import {
  currentUser,
  formatMoney,
  getBookById,
  libraryBooks,
  sampleOrders,
  savedAddresses,
} from "@/data/mock";
import { ReferralPanel } from "@/components/dashboard/referral-panel";

export const metadata = {
  title: "Dashboard",
};

const links = [
  { href: "/library", label: "Library", icon: BookMarked },
  { href: "/orders", label: "Orders", icon: Package },
  { href: "/wishlist", label: "Wishlist", icon: Gift },
  { href: "/blog", label: "Blog", icon: Sparkles },
  { href: "/support", label: "Support", icon: Bell },
  { href: "/auth", label: "Account", icon: Settings },
];

export default function DashboardPage() {
  const goalProgress = Math.round(
    (currentUser.booksReadThisYear / currentUser.readingGoal) * 100
  );

  return (
    <div className="mx-auto max-w-7xl px-4 py-10 sm:px-6 lg:px-8">
      <div className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <p className="text-primary text-sm font-semibold tracking-widest uppercase">
            Reading dashboard
          </p>
          <h1 className="font-heading mt-2 text-3xl font-bold tracking-tight">
            Welcome back, {currentUser.name.split(" ")[0]}
          </h1>
          <p className="text-muted-foreground mt-2 text-sm">
            {currentUser.membership} member · {currentUser.readingStreak}-day reading streak
          </p>
        </div>
        <Button asChild>
          <Link href="/books">Continue browsing</Link>
        </Button>
      </div>

      <div className="mt-8 grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {[
          {
            label: "Books read this year",
            value: String(currentUser.booksReadThisYear),
            icon: BookMarked,
          },
          {
            label: "Reading streak",
            value: `${currentUser.readingStreak} days`,
            icon: Trophy,
          },
          {
            label: "Wallet balance",
            value: formatMoney(currentUser.walletBalance),
            icon: Wallet,
          },
          {
            label: "Referral earnings",
            value: formatMoney(currentUser.referralEarnings),
            icon: Gift,
          },
        ].map((stat) => (
          <div
            key={stat.label}
            className="rounded-2xl border border-border/70 bg-card p-5 shadow-soft"
          >
            <div className="bg-primary/10 text-primary mb-3 flex size-10 items-center justify-center rounded-xl">
              <stat.icon className="size-5" />
            </div>
            <p className="text-muted-foreground text-xs tracking-wide uppercase">{stat.label}</p>
            <p className="font-heading mt-1 text-2xl font-bold">{stat.value}</p>
          </div>
        ))}
      </div>

      <div className="mt-8 grid gap-6 lg:grid-cols-12">
        <section className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft lg:col-span-7">
          <div className="flex items-center justify-between gap-3">
            <h2 className="font-heading text-lg font-semibold">Reading goal</h2>
            <span className="text-muted-foreground text-sm">
              {currentUser.booksReadThisYear}/{currentUser.readingGoal} books
            </span>
          </div>
          <Progress value={goalProgress} className="mt-4 h-2.5" />
          <p className="text-muted-foreground mt-3 text-sm">
            You&apos;re {goalProgress}% toward your {new Date().getFullYear()} goal. Keep the streak
            alive.
          </p>

          <h3 className="font-heading mt-8 text-sm font-semibold tracking-wide uppercase">
            Continue reading
          </h3>
          <div className="mt-4 grid gap-4 sm:grid-cols-2">
            {libraryBooks.slice(0, 2).map((item) => {
              const book = getBookById(item.bookId);
              if (!book) return null;
              return (
                <Link
                  key={item.bookId}
                  href="/library"
                  className="flex gap-3 rounded-2xl border border-border/60 p-3 transition hover:border-primary/30"
                >
                  <BookCover book={book} size="sm" className="w-14" />
                  <div className="min-w-0">
                    <p className="truncate text-sm font-semibold">{book.title}</p>
                    <p className="text-muted-foreground text-xs">{item.progress}% complete</p>
                    <Progress value={item.progress} className="mt-2 h-1.5" />
                  </div>
                </Link>
              );
            })}
          </div>
        </section>

        <section className="space-y-4 lg:col-span-5">
          <div className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <h2 className="font-heading text-lg font-semibold">Quick links</h2>
            <div className="mt-4 grid grid-cols-2 gap-2">
              {links.map((link) => (
                <Link
                  key={link.href}
                  href={link.href}
                  className="hover:bg-muted flex items-center gap-2 rounded-xl px-3 py-2.5 text-sm font-medium transition"
                >
                  <link.icon className="text-primary size-4" />
                  {link.label}
                </Link>
              ))}
            </div>
          </div>

          <div className="rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
            <div className="flex items-center gap-2">
              <MapPin className="text-primary size-4" />
              <h2 className="font-heading text-lg font-semibold">Saved addresses</h2>
            </div>
            <ul className="mt-4 space-y-3">
              {savedAddresses.map((a) => (
                <li key={a.id} className="text-sm">
                  <p className="font-medium">
                    {a.label}
                    {a.isDefault ? " · Default" : ""}
                  </p>
                  <p className="text-muted-foreground">
                    {a.line1}, {a.city}
                  </p>
                </li>
              ))}
            </ul>
          </div>
        </section>
      </div>

      <section className="mt-8 rounded-3xl border border-border/70 bg-card p-6 shadow-soft">
        <div className="flex items-center justify-between">
          <h2 className="font-heading text-lg font-semibold">Recent orders</h2>
          <Button variant="ghost" asChild>
            <Link href="/orders">View all</Link>
          </Button>
        </div>
        <div className="mt-4 divide-y divide-border/70">
          {sampleOrders.map((order) => (
            <div
              key={order.id}
              className="flex flex-wrap items-center justify-between gap-3 py-4 text-sm"
            >
              <div>
                <p className="font-medium">{order.number}</p>
                <p className="text-muted-foreground capitalize">
                  {order.status} · {order.items.length} item
                  {order.items.length === 1 ? "" : "s"}
                </p>
              </div>
              <p className="font-heading font-semibold">{formatMoney(order.total)}</p>
            </div>
          ))}
        </div>
      </section>

      <ReferralPanel />
    </div>
  );
}
