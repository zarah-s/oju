use oju_contracts::health_check::{IHealthCheckDispatcher, IHealthCheckDispatcherTrait};
use snforge_std::{ContractClassTrait, DeclareResultTrait, declare};

/// Deploys a fresh HealthCheck instance and returns its dispatcher.
fn deploy_health_check() -> IHealthCheckDispatcher {
    let contract = declare("HealthCheck").unwrap().contract_class();
    let (contract_address, _) = contract.deploy(@array![]).unwrap();
    IHealthCheckDispatcher { contract_address }
}

#[test]
fn beats_starts_at_zero() {
    let health = deploy_health_check();
    assert(health.beats() == 0, 'beats should start at zero');
}

#[test]
fn beat_increments_the_count() {
    let health = deploy_health_check();
    health.beat();
    health.beat();
    assert(health.beats() == 2, 'beats should equal two');
}
