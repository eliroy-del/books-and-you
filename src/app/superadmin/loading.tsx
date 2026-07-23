export default function Loading() {
  return (
    <div className="space-y-4 p-2">
      <div className="h-8 w-56 animate-pulse rounded-xl bg-white/10" />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="h-24 animate-pulse rounded-2xl bg-white/5" />
        ))}
      </div>
      <div className="h-64 animate-pulse rounded-2xl bg-white/5" />
    </div>
  );
}
