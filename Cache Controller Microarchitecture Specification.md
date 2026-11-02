

Oct 24, 2026 · @illgeece

https://makerchip.com/v201/ide/~0gJfxcj/p-0lQc1

This spec defines a blocking L1 cache controller before any RTL is written; fill it in top to bottom, because each section constrains the next.

- Italic lines are prompts. Delete each one once its section is written.
- `<angle brackets>` mark a value you choose. Empty table cells are yours to fill.
- Write the spec so someone else could build the RTL from it without asking you a question. That is the bar a design review will hold it to.
- Primary reference: Cornell ECE 4750 Lab 3 (Blocking Cache). Reference RTL: ZipCPU `dcache.v`, Wally `cache.sv`.

## 1. Document control

*Record every change that affects the RTL. A reviewer should be able to tell which revision of the spec a given RTL commit implements.*

| Rev | Date | Author | Change summary |
| --- | --- | --- | --- |
| 0.1 | 10/24/26 | me | Initial draft |
|  |  |  |  |

**Status:** `Draft`

**Related documents:** `<RV32I core spec, bus protocol spec, test plan>`

## 2. Overview and scope

*One paragraph a manager could read: what this block is, where it sits in the system, and what problem it solves.*

`<Summary paragraph>`

**Features (in scope for this revision)**

- *Write policy on hit:* `write-back`
- *Write policy on miss:* `write-allocate`
- *Organization:* `direct-mapped`
- *Blocking behavior:* `<blocking: one outstanding miss>`

**Non-goals (explicitly out of scope)**

*Naming what you will NOT build keeps the first revision small and tells the verifier what not to test.*

- `<e.g. coherence, non-blocking misses, byte-enable writes>`

**Assumptions about the environment**

*What must be true of the CPU and the memory for this design to be correct? List each one; every assumption is a future bug if it changes.*

- `<e.g. CPU holds a request stable until it is accepted>`
- `<e.g. memory returns a full line in one response beat>`

## 3. Configuration parameters

*List every value that should be a parameter rather than a hard-coded number. Derived values get a formula, not a number, so changing one parameter cannot leave the others stale.*

| Parameter | Description | Default | Legal range | Derived? (formula) |
| --- | --- | --- | --- | --- |
| `ADDR_W` | Address width (bits) |  |  |  |
| `WORD_W` | CPU word width (bits) |  |  |  |
| `LINE_BYTES` | Bytes per cache line |  |  |  |
| `NUM_SETS` | Number of sets |  |  |  |
| `NUM_WAYS` | Associativity |  |  |  |
| `CAPACITY_BYTES` | Total data capacity |  |  |  |
| `OFFSET_W` | Offset field width |  |  |  |
| `INDEX_W` | Index field width |  |  |  |
| `TAG_W` | Tag field width |  |  |  |
|  |  |  |  |  |

## 4. Interfaces

*The ports are the contract with the rest of the system. Define them before the internals, because the CPU and the memory model will be written against this section alone.*

### 4.1 Clock and reset

| Signal | Dir | Width | Description |
| --- | --- | --- | --- |
| `clk` | in | 1 |  |
| `reset` | in | 1 | *Sync or async? Active high or low?* |

### 4.2 CPU-side request channel

| Signal | Dir | Width | Description |
| --- | --- | --- | --- |
|  |  |  |  |
|  |  |  |  |

### 4.3 CPU-side response channel

| Signal | Dir | Width | Description |
| --- | --- | --- | --- |
|  |  |  |  |

### 4.4 Memory-side request channel

| Signal | Dir | Width | Description |
| --- | --- | --- | --- |
|  |  |  |  |

### 4.5 Memory-side response channel

| Signal | Dir | Width | Description |
| --- | --- | --- | --- |
|  |  |  |  |

### 4.6 Handshake protocol rules

*State the rules each side must obey. These become assertions in your testbench, so write them as checkable sentences.*

1. A transfer occurs when `<condition>`.
2. Once asserted, `<valid>` may not drop until `<condition>`.
3. Payload signals must stay stable while `<condition>`.
4. `<ready>` may / may not depend combinationally on `<valid>`: `<choice and why>`.
5. `<maximum outstanding requests on each channel>`

## 5. Architecture overview

*Start from this context diagram. Once §7–§9 are written, replace it with your own block diagram, and label every arrow with a signal name from §4 or §8.*

&#91;embedded content: context diagram · placeholder labels\]

**Datapath and control partition:** *Why separate the two? What does the split buy you in debugging, in reuse when you go to N ways, and in mapping onto TL-Verilog scopes?*

`<answer>`

**Top-level hierarchy:** *Which modules or TLV scopes will exist, and which file holds each?*

| Module / scope | Contents | File |
| --- | --- | --- |
|  |  |  |
|  |  |  |

## 6. Address decomposition

*Show exactly which address bits form each field. Check that the widths add up to `ADDR_W`; a one-bit slip here produces a cache that passes small tests and fails large ones.*

| Field | Bit range | Width | Used for |
| --- | --- | --- | --- |
| Tag | `[ : ]` |  |  |
| Index | `[ : ]` |  |  |
| Word offset | `[ : ]` |  |  |
| Byte offset | `[ : ]` |  |  |

**Worked example:** *Pick one address, split it by hand, and name the set and word it maps to.*

`<address>` → tag = `<>`, index = `<>`, word = `<>`

**Two addresses that conflict:** *Give two addresses that map to the same set with different tags. You will reuse them as a directed test.*

`<address A>`, `<address B>`

## 7. Storage structures

*For each array, decide what implements it (flip-flops or an SRAM macro), how many read and write ports it needs, and whether a read returns data the same cycle or the next. That last choice sets your hit latency.*

| Structure | Entries × width | Implementation | Read ports | Write ports | Read latency | Reset value |
| --- | --- | --- | --- | --- | --- | --- |
| Tag array |  |  |  |  |  |  |
| Data array |  |  |  |  |  |  |
| Valid bits |  |  |  |  |  |  |
| Dirty bits |  |  |  |  |  |  |
| Replacement state |  |  |  |  |  |  |

**Why valid and dirty bits are stored separately from the tag array:** `<your reasoning>`

**Replacement policy:** `<none for direct-mapped / LRU / pseudo-LRU>`. *Describe when the state updates (on hit, on fill, both) and how a victim is chosen.*

## 8. Datapath

*List every register, mux and comparator, and name the control signal that drives each one. Every control signal named here must show up as an output in the FSM output table (§9.3); that cross-check is how you catch a missing control line before simulation does.*

### 8.1 Registers

| Register | Width | Loaded when (control signal) | Purpose |
| --- | --- | --- | --- |
| Request address latch |  |  |  |
| Request data latch |  |  |  |
| Request type latch |  |  |  |
|  |  |  |  |

### 8.2 Multiplexers

| Mux | Inputs | Select signal | Purpose |
| --- | --- | --- | --- |
| Data array write-data source |  |  |  |
| Memory request address source |  |  |  |
|  |  |  |  |

### 8.3 Comparators and status signals sent to control

| Status signal | Computed as | Used by state(s) |
| --- | --- | --- |
| `tag_match` |  |  |
| `hit` |  |  |
| `victim_dirty` |  |  |
|  |  |  |

## 9. Control FSM

*Fill in one row per state. Ask of every state: what does it wait on, what does it change, and where can it go next? A state that waits on nothing is often a candidate to merge with its neighbor.*

**Encoding:** `<binary / one-hot>`, chosen because `<reason>`.

### 9.1 State list

| State  | **Abbv** | Purpose | Waits on | Cycles spent |
| ------ | -------- | ------- | -------- | ------------ |
| `IDLE` |          |         |          |              |
|        |          |         |          |              |
|        |          |         |          |              |
|        |          |         |          |              |

### 9.2 Transition table

*Conditions leaving a state must cover every case and must not overlap. If two can be true at once, write down the priority.*

| Current state | Condition     | Next state | Priority |
| ------------- | ------------- | ---------- | -------- |
| `IDLE`        | $cachereq_val |            |          |
|               |               |            |          |
|               |               |            |          |

### 9.3 Output table

*One column per control signal from §8. A blank cell means the signal is deasserted in that state.*

| State | `<ctrl 1>` | `<ctrl 2>` | `<ctrl 3>` | `<ctrl 4>` | `cpu_req_rdy` | `mem_req_val` |
| --- | --- | --- | --- | --- | --- | --- |
| `IDLE` |  |  |  |  |  |  |
|  |  |  |  |  |  |  |
|  |  |  |  |  |  |  |

### 9.4 State diagram

*Draw the diagram yourself from §9.1 and §9.2 (by hand or in a tool) and paste it here. Drawing it after writing the tables lets you see any state you cannot reach or cannot leave.*

`<diagram>`

## 10. Transaction flows

*Trace each case cycle by cycle through the states of §9. If you cannot finish a trace from your own tables, the tables are incomplete. Each finished trace becomes an expected waveform for a directed test.*

| Case | State sequence | Total cycles | Memory traffic |
| --- | --- | --- | --- |
| Read hit |  |  | none |
| Write hit |  |  |  |
| Read miss, clean victim |  |  |  |
| Read miss, dirty victim |  |  |  |
| Write miss, clean victim |  |  |  |
| Write miss, dirty victim |  |  |  |

**Cycle-by-cycle trace: read miss, dirty victim**

*Do one full trace for the worst case. Columns are cycles; rows are the signals you would probe in the waveform.*

| Signal | C0 | C1 | C2 | C3 | C4 | C5 | C6 | … |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| state |  |  |  |  |  |  |  |  |
| `cpu_req_val` / `rdy` |  |  |  |  |  |  |  |  |
| `mem_req_val` / `rdy` |  |  |  |  |  |  |  |  |
| `mem_resp_val` |  |  |  |  |  |  |  |  |
| `cpu_resp_val` |  |  |  |  |  |  |  |  |

## 11. Timing, latency and TL-Verilog stage mapping

*This section ties the spec to how you will write it. Decide which work happens in which `@N` stage and which signals must cross stages with `>>N`.*

**Hit latency target:** `<N>` cycles. **Reason:** `<why this number>`

**Miss penalty:** `<formula in terms of memory latency>`

| TLV stage | Work performed | Signals produced | Signals consumed from other stages (`>>N`) |
| --- | --- | --- | --- |
| `@0` |  |  |  |
| `@1` |  |  |  |
| `@2` |  |  |  |

**State storage:** *Where does the FSM state register live, and which stage reads its previous value with `>>1`?*

`<answer>`

**Critical path guess:** *Which combinational path do you expect to be longest (for example tag read → compare → hit → next state)?*

`<answer>`

## 12. Reset, initialization and corner cases

**Reset behavior:** *What state is every register and array in after reset? How many cycles until the first request is accepted?*

`<answer>`

**Initialization or flush:** *Is there a way to invalidate all lines or write back all dirty lines? If not, say so and give the reason.*

`<answer>`

**Corner cases:** *For each one, say what the design does. "Cannot happen" is a valid answer only if you name the assumption from §2 that rules it out.*

| Case | Expected behavior |
| --- | --- |
| A request arrives while a miss is in progress |  |
| Two back-to-back accesses to the same line |  |
| A write hits a line that is already dirty |  |
| Memory holds `mem_req_rdy` low for many cycles |  |
| A request arrives in the cycle reset is released |  |
| Misaligned address |  |
|  |  |

## 13. Performance targets

*Set the targets before measuring, so the results can show whether the design met them.*

| Metric | Target | Measured | Test or workload |
| --- | --- | --- | --- |
| Hit latency (cycles) |  |  |  |
| Miss penalty, clean (cycles) |  |  |  |
| Miss penalty, dirty (cycles) |  |  |  |
| Miss rate on `<workload>` |  |  |  |
| Average memory access latency |  |  |  |

**Average memory access latency:** *Write the formula you will use.*

`<formula>`

## 14. Verification plan

*Write this before the RTL. Every row of §10 and §12 should map to at least one test below; an unmapped row is an untested behavior.*

**Reference model:** *What predicts the correct answer? (For example a flat memory array that every response is checked against.)*

`<answer>`

**Test bench structure:** *Stimulus source, memory model (with configurable latency?), checker, coverage collection.*

`<answer>`

### 14.1 Directed tests

| Test name | Spec section covered | What it checks | Status |
| --- | --- | --- | --- |
|  |  |  |  |
|  |  |  |  |
|  |  |  |  |

### 14.2 Random tests

| Test name | Address range / distribution | Read:write mix | Seed(s) | Status |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |

### 14.3 Assertions

*Turn each handshake rule in §4.6 and each "never" statement in the spec into an assertion.*

| Assertion | Spec source | Status |
| --- | --- | --- |
|  | §4.6 rule 2 |  |
|  |  |  |

### 14.4 Coverage goals

- [ ] Every FSM state visited
- [ ] Every transition in §9.2 taken
- [ ] Every case in §10 exercised
- [ ] Every corner case in §12 exercised
- [ ] `<other coverage goal>`

## 15. Future extensions and open questions

### 15.1 Planned extensions

*For each one, note which sections of this spec it would change. If the answer is "almost all of them", a different structure now may make the extension cheaper later.*

| Extension | Sections affected | Hooks to leave in this revision |
| --- | --- | --- |
| N-way set associativity + replacement |  |  |
| Split instruction and data caches |  |  |
| Bus interface (AXI4-Lite / Wishbone) |  |  |
| 1-cycle hit (pipelined tag check) |  |  |
| Non-blocking misses (MSHRs) |  |  |
| Byte and halfword writes |  |  |

### 15.2 Open questions

- [ ] `<question>`
- [ ] `<question>`
