/** Landing page. Replaced by the markets UI in later milestones. */
export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 p-8 text-center">
      <p className="text-sm font-medium tracking-widest text-neutral-400 uppercase">
        Public odds · Invisible participants
      </p>
      <h1 className="text-5xl font-bold tracking-tight sm:text-7xl">Oju</h1>
      <p className="max-w-xl text-lg text-neutral-300">
        The market that sees, without being seen. Prediction markets built on Nigerian specifics, open to the
        world, private by design on Starknet.
      </p>
      <p className="text-sm text-neutral-500">Markets open soon.</p>
    </main>
  );
}
