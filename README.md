# ParametricInsurance Smart Contract

A decentralized parametric insurance smart contract built on Ethereum using Solidity. This contract automates insurance policies and payouts based on objective data thresholds provided by verified blockchain Oracles.

---

## 📌 Overview

The **ParametricInsurance** smart contract eliminates traditional, lengthy insurance claim processes. Instead of manually verifying damages, it triggers automated payouts based on pre-agreed parameters (e.g., specific weather metrics, flight delay hours). When a verified Oracle submits data that meets or exceeds the policy's target threshold, the contract instantly transfers the payout amount to the insured party.

---

## 🛠 Features

* **Automated Claims Handling:** No paperwork or manual claims assessment; payouts are purely data-driven and instantaneous.
* **Oracle Verification Architecture:** Integrates a multi-role model where only verified data feeds (`verifiedOracles`) can trigger policy outcomes.
* **Role-Based Security:** Strict access control ensures that only the `insurer` can authorize new oracle addresses.
* **State Protection Guards:** Protects against double-claiming by systematically marking policies inactive immediately upon execution.

---

## 📄 Smart Contract Architecture

### Data Structures

#### `Policy` (Struct)
Tracks the metrics of an active insurance coverage:
* `premium`: The amount of Ether paid by the user to activate the policy.
* `payoutAmount`: The guaranteed Ether amount the user receives if conditions are met.
* `targetCondition`: The specific data metric threshold (e.g., rainfall level, temperature, or delay time) required to trigger the claim.
* `isActive`: A state flag indicating whether the policy is currently valid.
* `claimed`: A safety flag preventing a policy from being paid out more than once.

### State Variables
* `insurer`: The Ethereum wallet address of the insurance provider (contract deployer).
* `policies`: A public mapping linking an insured user's address to their respective `Policy` details.
* `verifiedOracles`: A public mapping (`oracleAddress => bool`) tracking trusted external data providers.

---

## ⚙️ Core Functions

#### 1. `addOracle(address _oracle)`
* **Permission:** Only `insurer`
* **Description:** Authorizes a trusted external data provider/oracle address to submit condition updates.

#### 2. `purchasePolicy(uint256 _targetCondition, uint256 _payoutAmount)`
* **Permission:** Public (Requires Ether deposit as premium)
* **Description:** Allows any user to buy insurance by defining their target risk condition threshold and desired payout amount.

#### 3. `triggerPayout(address _insured, uint256 _actualCondition)`
* **Permission:** Only `verifiedOracles`
* **Description:** Evaluates the real-world metric (`_actualCondition`) against the user's `targetCondition`. If the threshold is met, the policy status is updated, and the contract automatically dispatches the `payoutAmount` directly to the policyholder.

---

## 🔔 Events

* `PolicyPurchased(address indexed insured, uint256 premium, uint256 payout)`: Emitted when a user successfully enters into a contract.
* `PolicyTriggered(address indexed insured, uint256 payout)`: Emitted when a data threshold is broken and the claim is settled.

---

## 🚀 Tech Stack & Setup

* **Language:** Solidity `^0.8.20`
* **Tools:** Remix IDE / Hardhat / Foundry

### Standard Deploy Instructions

1. Open **Remix IDE**.
2. Create a file named `ParametricInsurance.sol` and paste the code.
3. Select the compiler version to `0.8.20` and compile the code.
4. Deploy the contract. The wallet used for deployment will automatically become the `insurer`.
5. **Note:** Ensure the contract has enough Ether liquidity (via the `receive` function or direct funding) to back up potential policy payouts.

---

## ⚖️ License

This project is licensed under the **MIT License**.
