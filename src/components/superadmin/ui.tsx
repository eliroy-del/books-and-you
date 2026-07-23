import type { ReactNode } from "react";
import { cn } from "@/lib/utils";

export function SaHeader({
  title,
  description,
  action,
}: {
  title: string;
  description?: string;
  action?: ReactNode;
}) {
  return (
    <div className="mb-6 flex flex-wrap items-start justify-between gap-3">
      <div>
        <h1 className="font-heading text-2xl font-bold tracking-tight text-white sm:text-3xl">
          {title}
        </h1>
        {description ? <p className="mt-2 max-w-2xl text-sm text-slate-400">{description}</p> : null}
      </div>
      {action}
    </div>
  );
}

export function SaCard({
  title,
  children,
  className,
}: {
  title?: string;
  children: ReactNode;
  className?: string;
}) {
  return (
    <section
      className={cn(
        "rounded-2xl border border-white/10 bg-white/5 p-5 backdrop-blur sm:p-6",
        className
      )}
    >
      {title ? <h2 className="font-heading mb-4 font-semibold text-white">{title}</h2> : null}
      {children}
    </section>
  );
}

export function SaStat({ label, value }: { label: string; value: string }) {
  return (
    <div className="rounded-2xl border border-white/10 bg-white/5 p-5 backdrop-blur">
      <p className="text-xs tracking-wide text-slate-400 uppercase">{label}</p>
      <p className="font-heading mt-2 text-2xl font-bold text-white">{value}</p>
    </div>
  );
}
