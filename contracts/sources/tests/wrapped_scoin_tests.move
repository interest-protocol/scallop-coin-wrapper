#[test_only]
module scallop_coin_wrapper::wrapped_scoin_tests {
 
 use sui::test_utils::{destroy, assert_eq};
 use sui::coin::{mint_for_testing, TreasuryCap, CoinMetadata};
 use sui::test_scenario::{Self as test, Scenario, next_tx, ctx};

 use scallop_coin_wrapper::usdc::{Self, USDC};
 use scallop_coin_wrapper::wsusdc::{Self, WSUSDC};
 use scallop_coin_wrapper::invalid_usdc::{Self, INVALID_USDC};

 use scallop_coin_wrapper::wrapped_scoin;

 #[test]
 public fun end_to_end() {
  let mut scenario = test::begin(@0x1);

  let test = &mut scenario;

  set_up(test);
  test.next_tx(@0x0);
  {
   let wrapped_treasury_cap = test.take_from_sender<TreasuryCap<WSUSDC>>();
   let coin_metadata = test.take_shared<CoinMetadata<USDC>>();
   let wscoin_metadata = test.take_shared<CoinMetadata<WSUSDC>>();

   let mut wrapped_treasury_cap = wrapped_scoin::new<USDC, WSUSDC>(
    wrapped_treasury_cap,
    &coin_metadata,
    &wscoin_metadata,
    test.ctx()
   );

   assert_eq(wrapped_treasury_cap.total_supply(), 0);
   assert_eq(wrapped_treasury_cap.total_underlying(), 0);

   let wrapped_scoin = wrapped_treasury_cap.mint(mint_for_testing(1000, test.ctx()), test.ctx());

   assert_eq(wrapped_treasury_cap.total_supply(), wrapped_scoin.value());
   assert_eq(wrapped_treasury_cap.total_underlying(), wrapped_scoin.value());
   assert_eq(wrapped_scoin.value(), 1000);

   let scoin = wrapped_treasury_cap.burn(wrapped_scoin , test.ctx());

   assert_eq(wrapped_treasury_cap.total_supply(), 0);
   assert_eq(wrapped_treasury_cap.total_underlying(), 0);
   assert_eq(scoin.burn_for_testing(), 1000);   

   destroy(wrapped_treasury_cap);
   test::return_shared(coin_metadata);
   test::return_shared(wscoin_metadata);
  };

  test::end(scenario);
 }

 fun set_up(test: &mut Scenario) {
  
  test.next_tx(@0x0);
  {
   usdc::init_for_testing(test.ctx());
   wsusdc::init_for_testing(test.ctx());
   invalid_usdc::init_for_testing(test.ctx());
  };
 } 

 #[test]
 #[expected_failure(abort_code = scallop_coin_wrapper::wrapped_scoin::ETreasuryCapMustHaveNoSupply)]
 fun treasury_cap_must_have_no_supply_test() {
  let mut scenario = test::begin(@0x1);

  let test = &mut scenario;

  set_up(test);
  test.next_tx(@0x0);
  {
   let mut wrapped_treasury_cap = test.take_from_sender<TreasuryCap<WSUSDC>>();
   let coin_metadata = test.take_shared<CoinMetadata<USDC>>();
   let wscoin_metadata = test.take_shared<CoinMetadata<WSUSDC>>();

   destroy(wrapped_treasury_cap.mint(1, test.ctx()));

   let wrapped_treasury_cap = wrapped_scoin::new<USDC, WSUSDC>(
    wrapped_treasury_cap,
    &coin_metadata,
    &wscoin_metadata,
    test.ctx()
   );

   destroy(wrapped_treasury_cap);
   test::return_shared(coin_metadata);
   test::return_shared(wscoin_metadata);
  };

  test::end(scenario);  
 }

 #[test]
 #[expected_failure(abort_code = scallop_coin_wrapper::wrapped_scoin::EIncorrectDecimals)]
 fun incorrect_decimals_test() {
  let mut scenario = test::begin(@0x1);

  let test = &mut scenario;

  set_up(test);
  test.next_tx(@0x0);
  {
   let wrapped_treasury_cap = test.take_from_sender<TreasuryCap<WSUSDC>>();
   let coin_metadata = test.take_shared<CoinMetadata<INVALID_USDC>>();
   let wscoin_metadata = test.take_shared<CoinMetadata<WSUSDC>>();

   let wrapped_treasury_cap = wrapped_scoin::new<INVALID_USDC, WSUSDC>(
    wrapped_treasury_cap,
    &coin_metadata,
    &wscoin_metadata,
    test.ctx()
   );

   destroy(wrapped_treasury_cap);
   test::return_shared(coin_metadata);
   test::return_shared(wscoin_metadata);
  };

  test::end(scenario);  
 } 
}