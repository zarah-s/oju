/// Interface of the pipeline-validation contract.
#[starknet::interface]
pub trait IHealthCheck<TContractState> {
    /// Returns the stored heartbeat count.
    fn beats(self: @TContractState) -> u64;
    /// Increments the heartbeat count by one.
    fn beat(ref self: TContractState);
}

/// Minimal contract used to validate the build, test, and CI pipeline.
/// Replaced by the real market contracts in later milestones.
#[starknet::contract]
pub mod HealthCheck {
    use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};

    #[storage]
    struct Storage {
        beats: u64,
    }

    #[abi(embed_v0)]
    impl HealthCheckImpl of super::IHealthCheck<ContractState> {
        fn beats(self: @ContractState) -> u64 {
            self.beats.read()
        }

        fn beat(ref self: ContractState) {
            self.beats.write(self.beats.read() + 1);
        }
    }
}
