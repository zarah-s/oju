# Roadmap

Build flow for Oju (working name), a privacy-first prediction market built on Nigerian specifics, open to the
world, on Starknet STRK20. Start to finish. Each milestone is a feature branch → PR → CI green → merge; we tick
the milestone only when it's merged, and tick subtasks as we complete them.

**Product:** parimutuel prediction pools with public odds and invisible participants. Positions enter privately
from the STRK20 pool; positions are tracked by bearer commitments; winnings return to the pool as encrypted
notes. Markets cover Nigeria-native questions (economy, policy, resources, culture, sports), naira-denominated
where relevant, settled in native USDC. Flagship v1 markets: a BTC/USD threshold market resolved trustlessly by
Pragma, and a USD/NGN rate market resolved by a documented-methodology multisig with a challenge window.

**Hackathon:** STRK20 Private Sprint. Submissions close August 31, 23:59 UTC. Judged deliverables: public repo +
license, live demo URL, 3-minute video, and 3+ verified mainnet transactions touching the STRK20 pool
(`strk20.json` manifest).

**Priority tags:** `[core]` = required to ship · `[edge]` = differentiator · `[stretch]` = drop first if time is
tight. Design, research, and positioning docs live in [`docs/`](./docs/).

---

## M0: Scaffold, CI & hackathon registration `[core]`

- [ ] Monorepo: `contracts/` (Scarb 2.20+, Starknet Foundry snforge, OZ cairo-contracts v3) + `frontend/`
      (Next.js 16, React 19, starknet.js 10, get-starknet, Ready wallet)
- [ ] Tooling: scarb fmt, snforge, eslint, prettier; GitHub Actions CI (contracts build + test + fmt, frontend
      build + lint + typecheck, repo format) green on a trivial contract
- [x] Public repo + MIT license + README (public is a hackathon requirement)
- [ ] Register: PR appending our entry to the hackathon `registry.json` (repo_url + telegram handles)
- [ ] PR → CI green → merge

## M1: Mainnet pipeline spike `[core]`

- [ ] Deploy an echo-style `privacy_invoke` helper (from the mainnet-proven template) via UDC
- [ ] With the Ready wallet: shield a small amount, run withdraw → invoke → open-note round trip on mainnet
- [ ] Record tx hashes; confirm wallet placeholders (`${poolAddress}`, `${openNoteIds[0]}`) behave as spec'd
- [ ] Decision gate: pipeline proven before market code begins
- [ ] PR → CI green → merge

## M2: Parimutuel market core (Cairo) `[core]`

- [ ] `PariMarket` singleton: market registry, YES/NO pools, close time, fee (losing pool only), max-pool cap
- [ ] Payout math with u256 intermediates; floor division; winners never below stake
- [ ] Edge cases: empty winning side → Void + refund, empty losing side → refund-fee-free, position-after-close
      revert, resolve-before-close revert, dust sweep after claim window
- [ ] snforge suite incl. property/fuzz tests (Σ payouts ≤ pool + distributable)
- [ ] PR → CI green → merge

## M3: Privacy surface `[core]`

- [ ] `privacy_invoke` entrypoint: Predict action (record `positions[commitment]`, accounted-balance check on
      the bare transfer in, empty deposit span) and Claim action (verify bearer secret, mark claimed, approve
      pool, return `OpenNoteDeposit` filling the claimer's open note)
- [ ] Caller guard (passed pool address equals caller), one-invoke-per-tx constraints respected
- [ ] snforge tests with mocked pool: predict, claim, double-claim, wrong-secret, losing-position, underflow
      guards
- [ ] PR → CI green → merge

## M4: Resolution `[core]`

- [ ] `IMarketResolver` seam on the market
- [ ] Pragma resolver: BTC/USD (and STRK/USD) threshold via `get_data_median` + checkpoint at expiry
- [ ] Documented-methodology resolver for Nigeria-native markets: multisig resolve with methodology hash
      committed at market creation, evidence URI at resolution, 24h challenge window before claims open `[edge]`
- [ ] Tests for both resolvers incl. void path
- [ ] PR → CI green → merge

## M5: Integration + mainnet deploy `[core]`

- [ ] e2e against the real pool using the starknet-privacy dockerized devnet harness (predict → resolve → claim
      through proven txs)
- [ ] Deploy `PariMarket` + resolvers to mainnet; verify; create the flagship markets; seed both sides
- [ ] Execute the real private cycle on mainnet: shield → private position → resolve → private claim (these
      become our 3+ judged transactions)
- [ ] PR → CI green → merge

## M6: Frontend core `[core]`

- [ ] Wallet connect (Ready), network guard, shield/unshield helpers
- [ ] Market list + detail by category (Economy, Policy, Resources, Culture, Sports): live pools → implied
      probability, countdown, committed methodology display
- [ ] Private position flow with fixed denominations (leak mitigation) via `strk20InvokeTransaction`
- [ ] Client-side position vault: bearer commitments/salts stored locally + export/backup
- [ ] Claim flow with open-note wiring; pending states for proof latency
- [ ] Error handling: not shielded, below denomination, market closed, wrong network
- [ ] PR → CI green → merge

## M7: Live deploy + submission manifest `[core]`

- [ ] Deploy frontend to a public URL (Vercel)
- [ ] `strk20.json` at repo root: transactions, contracts, demo_url, demo_video placeholder
- [ ] End-to-end run by a fresh user on mainnet
- [ ] PR → CI green → merge

## M8: Polish `[stretch]`

- [ ] Leak-mitigation UX: claim-timing jitter nudges, dwell-time guidance, thin-market warnings
- [ ] Public stats strip (pools, participants count, markets, next resolution)
- [ ] Naira-denominated display (₦ framing over USDC settlement); mobile pass
- [ ] PR → CI green → merge

## M9: README & docs `[core]`

- [ ] Judge-facing README: live URL, how it works, the privacy model and honest leakage table, resolution
      methodology, deploy instructions
- [ ] Architecture diagram; license check
- [ ] PR → CI green → merge

## M10: Demo video + submission `[core]`

- [ ] Script + record real-person 3-minute demo (shield → private position → odds → resolve → private claim)
- [ ] Publish video; finalize `strk20.json`; verify the hub shows all four deliverables
- [ ] Submit before August 31, 23:59 UTC

---

## v2 (post-hackathon, product roadmap)

**Track A: naira onramp.** Take positions in naira: fiat rails via local payment partners, onramp to USDC/USDT
behind the scenes, settlement choice of USDC, USDT (when STRK20-shieldable), or naira. Includes the
licensing/KYC compliance workstream.

**Track B: progressive decentralization.** Permissionless market creation, bonded optimistic resolution
replacing the multisig, open indexer/keeper infrastructure, decentralized backend behind the pools.

**Track C: market depth.** The full Nigeria-native catalog: inflation and fuel (NBS methodology), border and
policy events (official gazettes/announcements), resources and minerals (oil benchmarks, NNPC/OPEC data),
culture and influencer markets with crisply worded resolution criteria and named evidence sources, sports.
Outcome-token positions (privately transferable). NGN oracle integration when one exists on Starknet.
