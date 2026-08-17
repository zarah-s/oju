# Oju

> **The market that sees, without being seen.**

Oju (Yoruba: "eye") is a **privacy-first prediction market built on Nigerian specifics, open to the world**,
running on Starknet's [STRK20 privacy layer](https://www.starknet.io/blog/push-to-private/).

The odds are public. The participants are invisible.

---

## 💡 The idea in 30 seconds

Nigerians argue about the future every single day: will the naira cross ₦X? Will petrol hit ₦Y? Will the border
reopen? Will Peller be gifted another car? Oju turns those arguments into markets. Anyone in the world, locals,
the diaspora, global macro traders, can take a **position** on a Nigeria-native question and get paid for being
right.

The twist: on a normal chain, every position is public. Whole tool ecosystems exist to track and copy Polymarket
wallets, and in Nigeria a visible position on a sensitive question has real consequences (in 2024 the EFCC froze
**1,146 bank accounts** over FX/crypto activity). Oju uses STRK20 so that your funds, your positions, and your
winnings stay private, while the market's odds and resolution stay public and provable.

**On Polymarket, this exact position gets you copy-traded. In Nigeria, it can get you frozen.**

## 🎯 How it works

- **Parimutuel pools.** Every question has a YES and a NO bucket. Stakes pool per side; when the question
  resolves, the losing bucket (minus a small fee) is shared among the correct predictors pro-rata. The implied
  probability is just the ratio of the buckets, public for everyone.
- **Private positions.** Funds sit shielded in the STRK20 privacy pool as encrypted notes. A position leaves the
  pool without revealing whose it is, and is tracked by a bearer commitment only the participant can claim.
- **Private winnings.** Payouts flow straight back into the privacy pool as encrypted notes. Who won stays
  hidden.
- **Provable resolution.** Crypto markets resolve trustlessly via the [Pragma oracle](https://docs.pragma.build).
  Nigeria-native markets (naira rate, fuel, policy, culture) resolve against a source and methodology committed
  on-chain at market creation, with published evidence and a challenge window.

## 🗂️ Market catalog

| Category | Examples |
| --- | --- |
| Economy | Inflation above X%? Naira past ₦X/$? Petrol at ₦Y/litre? |
| Policy | Border reopening, subsidy decisions |
| Resources | Oil and minerals, production and benchmarks |
| Culture | Influencer questions, viral trends, BBNaija |
| Sports | Match and season outcomes |

Markets are naira-denominated where relevant and settled in native USDC on Starknet.

## 🔒 What is public vs hidden

Public: markets, pool totals and odds, each position's amount and side (never its owner), resolution evidence,
payout amounts (never their owners). Hidden: who took any position, who claimed any payout, balances inside the
privacy pool, the link between a person and their positions. The full honest leakage model and mitigations are
documented in [docs/design-research-decisions.md](./docs/design-research-decisions.md).

## 📚 Documentation

- [docs/overview-and-flow.md](./docs/overview-and-flow.md), the product and the full user flow in plain language
- [docs/design-research-decisions.md](./docs/design-research-decisions.md), verified architecture, privacy
  model, leakage table, resolution design
- [docs/market-and-pitch.md](./docs/market-and-pitch.md), market context, evidence, and positioning
- [roadmap.md](./roadmap.md), the milestone-by-milestone build plan

## 🏗️ Status

**Early build**, part of the [STRK20 Private Sprint](https://strk20.starknet.io/hackathon). Contracts (Cairo),
frontend (Next.js), live demo, and mainnet transactions land milestone by milestone; follow
[roadmap.md](./roadmap.md).

## 📄 License

[MIT](./LICENSE).
