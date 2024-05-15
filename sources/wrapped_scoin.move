module scallop_coin_wrapper::wrapped_scoin {
  // === Imports ===

  use sui::balance::{Self, Balance};
  use sui::coin::{Coin, CoinMetadata, TreasuryCap};

  // === Errors ===

  const ETreasuryCapMustHaveNoSupply: u64 = 0;
  const EIncorrectDecimals: u64 = 1;

  // === Constants ===

  // === Structs ===

  public struct WrappedTreasuryCap<phantom SCoin, phantom WrappedSCoin> has key {
   id: UID,
   inner: TreasuryCap<WrappedSCoin>,
   balance: Balance<SCoin>
  }

  // === Method Aliases ===

  // === Public-Mutative Functions ===

  /*
  * @dev E.g. 
  * Coin => USDC
  * SCoin => sUSDC
  * WrappedSCoin => Wrapped sUSDC
  */
  public fun new<Coin, SCoin, WrappedSCoin>(
   treasury_cap: TreasuryCap<WrappedSCoin>, 
   coin_coin_metadata: &CoinMetadata<Coin>,
   wscoin_coin_metadata: &CoinMetadata<WrappedSCoin>,
   ctx: &mut TxContext
  ): WrappedTreasuryCap<SCoin, WrappedSCoin> {
   assert!(treasury_cap.total_supply() == 0, ETreasuryCapMustHaveNoSupply);
   assert!(coin_coin_metadata.get_decimals() == wscoin_coin_metadata.get_decimals(), EIncorrectDecimals);

   WrappedTreasuryCap {
    id: object::new(ctx),
    inner: treasury_cap,
    balance: balance::zero()
   }
  }

  public fun share<SCoin, WrappedSCoin>(self: WrappedTreasuryCap<SCoin, WrappedSCoin>) {
   transfer::share_object(self);
  }

  // === Public-View Functions ===

  public fun total_supply<SCoin, WrappedSCoin>(self: &WrappedTreasuryCap<SCoin, WrappedSCoin>): u64 {
   self.inner.total_supply()
  }

  public fun total_underlying<SCoin, WrappedSCoin>(self: &WrappedTreasuryCap<SCoin, WrappedSCoin>): u64 {
   self.balance.value()
  }

  public fun mint<SCoin, WrappedSCoin>(
   self: &mut WrappedTreasuryCap<SCoin, WrappedSCoin>,
   underlying: Coin<SCoin>,
   ctx: &mut TxContext
  ): Coin<WrappedSCoin> {
    let value = underlying.value();
    self.balance.join(underlying.into_balance());
    self.inner.mint(value, ctx)
  }

  public fun burn<SCoin, WrappedSCoin>(
   self: &mut WrappedTreasuryCap<SCoin, WrappedSCoin>,
   derivative: Coin<WrappedSCoin>,
   ctx: &mut TxContext    
  ): Coin<SCoin> {
    let value = derivative.value();
    self.inner.burn(derivative);
    self.balance.split(value).into_coin(ctx)
  }

  // === Admin Functions ===

  // === Public-Package Functions ===

  // === Private Functions ===

  // === Test Functions ===  
}
