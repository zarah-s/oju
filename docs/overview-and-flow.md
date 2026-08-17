# Overview & Full Flow (plain language)

_Uncommitted working doc. For our understanding, not for the repo._

## 1. What we are building

**Oju** (working name, Yoruba for "eye": the market that sees, without being seen) is a **prediction market
built on Nigerian specifics, open to the world**. The odds are public but the participants are invisible.

People take **positions** (not "bets", we are a forecasting product) on questions Nigeria already argues about
daily:

- **Economy:** will inflation pass X%? Will the naira cross ₦X/$? Will petrol hit ₦Y/litre?
- **Policy:** will the border reopen by date X? Will the subsidy decision land this quarter?
- **Resources:** oil and minerals, production and benchmark questions.
- **Culture and trends:** will Peller be gifted another car? When does the next viral trend drop? BBNaija
  outcomes.
- **Sports:** match and season outcomes.

Locals, the diaspora, and global macro traders can all take positions. Nigeria is the content, not a
restriction on who can participate. Settlement is in stablecoins; display is naira-denominated where relevant.

## 2. Why privacy is the product, not a feature

In Nigeria, a visible financial position on a sensitive question has real consequences. Documented history:
protest supporters' bank accounts frozen (#EndSARS 2020), banks ordered to close crypto users' accounts (2021),
a Binance executive detained for months (2024), and the EFCC freezing 1,146 accounts over FX/crypto trading
(2024). On Polymarket, every position is public and whole tools exist to track and copy specific wallets.

The demo line: **"On Polymarket, this exact position gets you copy-traded. In Nigeria, it can get you frozen."**

STRK20 (Starknet's privacy layer) fixes this: funds sit in a shared privacy pool as encrypted notes; positions
come OUT of the pool without revealing whose they are; winnings go BACK IN as encrypted notes only the winner
controls.

## 3. How a market works (parimutuel, no jargon)

Every question has **outcome buckets** defined when the market is created: a simple YES/NO, a set of number
ranges ("naira ends the month at 1,400 to 1,500 / 1,500 to 1,600 / above 1,600"), a set of date ranges
("border reopens before September / September to October / later"), or categories. Everyone's stake goes into
their chosen bucket. When the question resolves, the winning bucket shares everyone else's pools (minus a small
fee) in proportion to stakes. Bigger stake, bigger share. The implied probability of each bucket at any moment
is simply its share of the total, public for everyone to see. No order book, no market maker, no house taking a
side.

Market creation is curated for the MVP. The v2 vision is **stake-to-operate**: anyone stakes to become an
operator, operators create pools around what's happening or about to trend, earn a share of fees, and have
their stake at risk for bad questions or resolutions. Decentralized infra, open for everyone to run.

## 4. The privacy flow, step by step

1. **Shield.** A user moves USDC into the STRK20 privacy pool with the Ready wallet (one click). From then on
   their balance is an encrypted note.
2. **Take a position privately.** The wallet builds one proven transaction: the stake leaves the pool to the
   market contract (the amount is visible, the person is not, the sender is just "the pool"), together with a
   **bearer commitment**, a fingerprint derived from a secret only the participant holds. The market records the
   position under that fingerprint. Change returns as encrypted notes.
3. **Odds move publicly.** The buckets update; everyone sees the implied probability; nobody sees who moved it.
4. **Resolution.** Crypto markets resolve automatically from the Pragma oracle (live on mainnet, free to read).
   Nigeria-native markets (naira, fuel, policy, culture) resolve by a multisig against a source and methodology
   committed on-chain at market creation (CBN rate, NBS data, official announcements, named evidence for
   culture questions), with an evidence link and a 24 hour challenge window. Honest, because no NGN oracle
   exists on Starknet today, and culture questions need crisply worded criteria.
5. **Claim privately.** The winner's wallet builds one proven transaction that opens a fresh empty note, reveals
   the bearer secret to the market inside that same atomic transaction (so nobody can steal it), and the payout
   flows straight back into the privacy pool as the winner's encrypted note. Who won stays hidden.
6. **Unshield anytime.** The user can withdraw from the pool to a public balance whenever they choose.

## 5. What is public vs hidden (the honest table)

Public: the markets, the bucket totals and implied odds, each position's amount and side (not its owner),
resolution data and evidence, payout amounts (not their owners), the market contract itself.

Hidden: who took any position, who claimed any payout, everyone's balances inside the pool, the link between a
person and their positions.

Known leaks and our mitigations: stake amounts can fingerprint people, so the UI enforces **fixed
denominations**; timing correlations, so the UI nudges dwell time and claim jitter; thin markets are
self-identifying, so we seed both sides and warn; relayer submission keeps fee payers unlinkable.

## 6. The judge demo (3 minutes)

Shield USDC → take a private position on "Will BTC close above $X" → show the odds moving with no identity on
Starkscan → resolve via Pragma → claim privately, payout lands as an encrypted note → show the naira market and
its committed methodology, and tease the culture catalog ("will Peller be gifted another car?"). Every step on
mainnet.

## 7. One-line summary

> Prediction markets built on Nigerian specifics, open to the world: public odds, invisible participants,
> provable resolution, on Starknet's STRK20 privacy pool, in a country where a visible position can cost you
> your bank account.
