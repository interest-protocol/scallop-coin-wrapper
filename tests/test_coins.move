#[test_only]
module scallop_coin_wrapper::usdc {
  use sui::coin;

  public struct USDC has drop {}

  #[lint_allow(share_owned)]
  fun init(witness: USDC, ctx: &mut TxContext) {
      let (treasury_cap, metadata) = coin::create_currency<USDC>(
            witness, 
            6, 
            b"USDC", 
            b"USDC Coin", 
            b"A stable coin issued by Circle",
            option::none(), 
            ctx
        );

      transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
      transfer::public_share_object(metadata);
  }

  #[test_only]
  public fun init_for_testing(ctx: &mut TxContext) {
    init(USDC {}, ctx);
  }
}

#[test_only]
module scallop_coin_wrapper::susdc {
  use sui::coin;

  public struct SUSDC has drop {}

  #[lint_allow(share_owned)]
  fun init(witness: SUSDC, ctx: &mut TxContext) {
      let (treasury_cap, metadata) = coin::create_currency<SUSDC>(
            witness, 
            6, 
            b"sUSDC", 
            b"sUSDC Coin", 
            b"Scallop interest bearing USDC",
            option::none(), 
            ctx
        );

      transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
      transfer::public_share_object(metadata);
  }

  #[test_only]
  public fun init_for_testing(ctx: &mut TxContext) {
    init(SUSDC {}, ctx);
  }
}

#[test_only]
module scallop_coin_wrapper::wsusdc {
  use sui::coin;

  public struct WSUSDC has drop {}

  #[lint_allow(share_owned)]
  fun init(witness: WSUSDC, ctx: &mut TxContext) {
      let (treasury_cap, metadata) = coin::create_currency<WSUSDC>(
            witness, 
            6, 
            b"Wrapped sUSDC", 
            b"Wrapped sUSDC Coin", 
            b"Scallop interest bearing USDC wrapper",
            option::none(), 
            ctx
        );

      transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
      transfer::public_share_object(metadata);
  }

  #[test_only]
  public fun init_for_testing(ctx: &mut TxContext) {
    init(WSUSDC {}, ctx);
  }
}

#[test_only]
module scallop_coin_wrapper::invalid_usdc {
  use sui::coin;

  public struct INVALID_USDC has drop {}

  #[lint_allow(share_owned)]
  fun init(witness: INVALID_USDC, ctx: &mut TxContext) {
      let (treasury_cap, metadata) = coin::create_currency<INVALID_USDC>(
            witness, 
            4, 
            b"USDC", 
            b"USDC Coin", 
            b"A stable coin issued by Circle",
            option::none(), 
            ctx
        );

      transfer::public_transfer(treasury_cap, tx_context::sender(ctx));
      transfer::public_share_object(metadata);
  }

  #[test_only]
  public fun init_for_testing(ctx: &mut TxContext) {
    init(INVALID_USDC {}, ctx);
  }
}