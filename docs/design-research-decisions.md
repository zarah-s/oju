# Design, Research & Decisions

_Uncommitted working doc. All key claims verified against primary sources (contract source, live RPC calls)._

## Locked decisions (confirmed with the user)

- **Name: Oju** (domain/trademark check before prod; committed for the hackathon).
- **Stake denominations: 10 / 25 / 50 / 100 USDC**, enforced in contract and UI (privacy k-anonymity).
- **Seeding: ~$50 total house seed** across both sides of each flagship market, disclosed transparently in docs.
- **Funding: confirmed**, ~50 to 80 STRK + ~$150 USDC on mainnet for the demo cycle.
- Language: positions/predictions, never "bet". Positioning: built on Nigerian specifics, open to the world.

## Feasibility verdict (all four research streams complete)

**GO.** The full private position → resolve → private claim cycle is feasible on Starknet mainnet in the window, via
the Wallet API path. Proof points:

- Pool integration is **permissionless**: `InvokeExternal` validates only a non-zero target address; execution is
  a raw `call_contract_syscall`; official anonymizers have empty constructors and no registration. Only gate is
  an opt-out depositor blocklist (default: not blocked).
- The **Ready wallet drives it**: `@starknet-io/types-js@0.10.3` defines `STRK20_INVOKE_ACTION` in the action
  union of `wallet_strk20InvokeTransaction`. The wallet proves, discovers notes, and substitutes
  `"${poolAddress}"` and `"${openNoteIds[N]}"` placeholders. **No self-hosted prover, no discovery service, no
  pool address needed.**
- A third-party `privacy_invoke` helper (starter kit echo contract) is **live on mainnet** at
  `0x78ae662e0cc6d1ab2cfeaf2a51ba8783d88e31886f88a794d142f95a6f8735b` and has been invoked **12 times by the
  real pool** (verified by direct RPC: class hash match + `get_invoke_count() = 0xc`).

## Architecture (v1)

One singleton **`PariMarket`** contract (multi-market registry) + resolver seam. No factory, no outcome tokens
in v1 (outcome-token positions are v2).

**Mechanism: N-outcome parimutuel** (binary is the 2-outcome special case). Each market defines its outcome
buckets at creation: YES/NO, number ranges (naira bands), date ranges, categories. Stakes pool per bucket; the
winning bucket splits all other pools pro-rata: `distributable = total − pool[W] − fee`,
`payout = s + s * distributable / pool[W]`, fee taken from losing pools only so winners never receive less than
stake. u256 intermediates, floor division, `max_pool ≤ 2^127`. Edge cases: empty winning bucket → Void +
universal refund; no losing stake → refund, no fee; dust + unclaimed swept by owner after a claim window;
position-after-close and resolve-before-close revert. An **operator role seam** is designed in from day one:
market creation is curated (owner/multisig) for MVP, and v2 stake-to-operate (bonded, slashable operators
creating pools permissionlessly) bolts onto the same role. Rejected alternatives: CLOB (needs an off-chain
matcher, Polymarket-style), AMM/LMSR (fixed-point exp/ln risk, house subsidy). Parimutuel is what
Zeitgeist/Hxro ship, pure integer math, zero house liability, and its "amount → bucket" shape matches the
anonymizer call exactly.

**Private position (one proven wallet tx):**
`[{withdraw → market, amount}, {invoke, market, calldata: [Predict{market_id, side, amount}, commitment, "${poolAddress}"]}]`
The stake arrives as a bare ERC-20 transfer before the invoke, so the market keeps an `accounted[token]` counter
and asserts `balance − accounted ≥ amount`. Records `positions[commitment] = {market_id, side, amount, claimed:
false}`. Returns an **empty** `OpenNoteDeposit` span (legal).

**Position ownership: bearer commitments.** `commitment = poseidon(secret, market_id)` with a fresh
client-generated secret per position, stored in the user's local position vault (with export/backup). At claim, the
secret is revealed **inside the atomically executing proven claim tx**, bound to the claimer's own open note, so
the reveal cannot be stolen or replayed. Note: the pool's fancier `compute_and_invoke` identity-key pseudonym is
NOT yet in the wallet action union (local SDK shims only), which is why v1 uses bearer commitments; migrate when
wallets ship it.

**Private claim (one proven wallet tx):**
`[{transfer, amount: "OPEN", recipient: self}, {invoke, market, calldata: [Claim{secret}, "${poolAddress}", "${openNoteIds[0]}"]}]`
Market verifies `poseidon(secret, market_id)` matches an unclaimed winning position, marks claimed, approves the
pool for the payout, returns `[OpenNoteDeposit{note_id, token, payout}]`; the pool pulls the tokens and fills the
winner's encrypted note. No screening on this open-note re-entry path.

**Pool constraints to respect:** at most one invoke per proven tx (predict and claim are separate txs anyway); every
open note created in a tx must be filled by the invoke, none extra; no reentry into the pool (ReentrancyGuard);
`privacy_invoke` is publicly callable, so guard by asserting the passed pool address equals the caller; wait
~10 finalized blocks between dependent privacy txs (prover reads finalized state).

## Resolution

- **Trustless flagship:** Pragma oracle, live on mainnet (verified by direct RPC call: BTC/USD $64,170 from 11
  sources at research time). Oracle `0x2a85bd616f912537c50a49a4076db02c00b29b2cdc8a197ce92ed1837fa875b`,
  `get_data_median(DataType::SpotEntry('BTC/USD'))`, free view call, checkpoints for at-expiry integrity. Pairs:
  BTC/USD (flagship, legible), STRK/USD (thematic), ETH/USD available.
- **Naira market:** **no NGN oracle exists on Starknet** (verified: Pragma NGN probe returns zeros; Chainlink has
  7 crypto feeds only; Stork absent; Pyth lists USD/NGN but sunsets Starknet Aug 18, 2026 and does not serve NGN
  on the core tier). Design: 2-of-3 multisig resolves against the **CBN official closing rate**, methodology +
  source hash committed on-chain at market creation, evidence URI at resolution, 24h challenge window before
  claims. Fuel/inflation markets identical with NBS as source. No UMA-style optimistic oracle exists on Starknet;
  a bonded challenge window is itself a differentiator.

## Tokens

- **No naira stablecoin on Starknet** (cNGN is on 8 other chains). Markets are naira-denominated, USDC-settled.
- **STRK20 shieldable set today: native USDC, STRK, strkBTC.** USDT/ETH not yet (v2 "when supported").
- Native USDC (Circle): `0x033068F6539f8e6e6b131e6B2B814e6c34A5224bC66947c47DaB9dFeE93b35fb` (verified
  on-chain). STRK: `0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d`. Private txs cost a
  flat ~4 STRK.

## Leak inventory (goes in the judged README)

| Leak                                                          | Mitigation                                  |
| ------------------------------------------------------------- | ------------------------------------------- |
| Stake amount visible at execution (inherent to STRK20 invoke) | Fixed stake denominations → k-anonymity     |
| Payout arithmetic fingerprints stake                          | Same fixed denominations                    |
| Deposit-then-position timing correlation                      | Dwell-time guidance, batching windows       |
| Claim timing shrinks the crowd                                | Long claim window + jitter nudges           |
| Fee-payer address on `apply_actions`                          | Relayer submission (any address may submit) |
| Thin markets self-identify                                    | Seed both sides at creation, warn users     |
| Commitment reuse links positions                              | Fresh secret per position, enforced unused  |

Honest statement: position↔claim linkage is largely inherent to parimutuel accounting (payout is computable from
stake). We hide identities, not amounts. Never overclaim (costs integration-depth points).

## Reference code (paths in scratchpad checkouts)

- `starkware-libs/starknet-privacy`: `packages/ekubo_swap_anonymizer/` (minimal privacy_invoke shape, 163
  lines), `packages/shadow_account_anonymizer/` (commitment patterns), `packages/privacy/src/{actions,objects,
interface,privacy,hashes}.cairo`, `e2e/tests/devnet/*` (SDK recipes + dockerized devnet harness),
  `client/src/builder.ts`.
- `Akashneelesh/strk20-starter-kit`: wallet wiring (`WalletAccountV6Tag.tsx`), echo helper Cairo + mainnet
  address in `cairo/address.md`, Next.js 16 scaffold.
- `raize-club/raize_contracts`: production Starknet parimutuel logic to port (not reuse, older Cairo).
- OZ cairo-contracts v3.0.0: Ownable, ReentrancyGuard, Pausable, Upgradeable components.

## Toolchain

Contracts: Scarb 2.20.x, Starknet Foundry (snforge 0.62+), OZ v3.0.0. Frontend: Next.js 16, React 19,
starknet.js 10.4, `@starknet-io/get-starknet-discovery` 6.0.2, `@starknet-io/types-js` 0.10.3, Ready wallet.
Node ≥ 20 (frontend), Alchemy RPC. Deploy: sncast + UDC; Vercel for the app.

## Hackathon logistics

Registration: one PR appending `{repo_url, telegram[]}` to `registry.json` at
`github.com/starkience/strk20-hackathon` (bot auto-merges; hub reads our repo every 30 min afterward).
Deliverables in `strk20.json` at OUR repo root: `transactions` (3+ mainnet hashes touching the pool),
`demo_video`, `contracts`, `demo_url`. Judging: 30% integration depth, 30% working mainnet product, 25%
innovation, 15% docs/OSS. Deadline Aug 31 23:59 UTC; winners Sept 4. Field: 63 registered, ~7 in
prediction/betting adjacents (blindpool starred with a live demo, Veilcast), but at research time zero projects
had 3+ verified txs, so shipping deliverables early matters. Our differentiation vs blindpool/Veilcast: the
Nigeria wedge, parimutuel + bearer-commitment claims, Pragma trustless resolution, and the documented-methodology
naira market.

## Risks / watch-items

1. Ready wallet behavior on mainnet with a custom invoke is our M1 spike (spec + mainnet evidence say yes; we
   verify day 1 with our own hands).
2. Governance could blocklist our depositor address after the fact (opt-out risk, low, be a good citizen).
3. STRK20 is RC software (`PRIVACY-0.14.3-RC`), API churn possible; pin versions.
4. 10-block finalization gaps between dependent privacy txs; build the wait into UX and the demo script.
5. Bearer-secret loss = unclaimable position; the client vault needs export/backup UX.
6. Deadline math is tight: core cycle must be on mainnet by ~Aug 27 to leave room for video + submission.
7. Regulatory (prod, not hackathon): Nigerian gaming law in state-level flux, prediction markets unaddressed;
   frame as information markets; privacy will be read through an AML lens, selective disclosure is the answer.
