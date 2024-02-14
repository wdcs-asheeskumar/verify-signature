//SPDX-License-Identifier:MIT
pragma solidity ^0.6.0;

import "https://github.com/aave/protocol-v2/blob/master/contracts/protocol/lendingpool/LendingPool.sol";
import "https://github.com/aave/protocol-v2/blob/master/contracts/protocol/configuration/LendingPoolAddressesProvider.sol";

contract AaveIntegration {
    LendingPoolAddressesProvider provider =
        LendingPoolAddressesProvider(
            address(0x5E52dEc931FFb32f609681B8438A51c675cc232d)
        );
    LendingPool lendingPool = LendingPool(provider.getLendingPool());
    address public addLend = provider.getLendingPool();

    //Input variable
    address public MyToken1 =
        address(0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a);
    uint256 public amount = 10000000000000;
    uint16 public referral = 12;
    // uint256 public max_amount_borrow;
    // uint256 public interestRateMode;
    // uint256 public borrowAmount;
    // uint256 public totalBalance;
    address public onBehalfOf = msg.sender;
    // bool public useAsCollateral = true;
    address public poolAddress = provider.getLendingPool();

    // constructor(uint256 cz) public {
    //     max_amount_borrow = (amount * (100 - cz)) / 100;
    // }

    function approveTokens() external {
        IERC20(MyToken1).approve(provider.getLendingPool(), amount);
    }

    function depositTokens() external {
        ILendingPool(provider.getLendingPool()).deposit(
            MyToken1,
            amount,
            onBehalfOf,
            referral
        );
    }

    // function withdrawTokens(uint256 _amountWithdraw) external {
    //     require(_amountWithdraw <= amount, "insufficient amount");
    //     lendingPool.withdraw(
    //         provider.getLendingPool(),
    //         _amountWithdraw,
    //         MyToken1
    //     );
    // }

    // function borrowToken(uint256 _borrowAmount, uint256 _interestRateMode)
    //     external
    // {
    //     borrowAmount = _borrowAmount;
    //     require(
    //         max_amount_borrow <= borrowAmount,
    //         "Amount exceeds borrowing limit"
    //     );
    //     interestRateMode = _interestRateMode;
    //     lendingPool.borrow(
    //         provider.getLendingPool(),
    //         _borrowAmount,
    //         interestRateMode,
    //         referral,
    //         onBehalfOf
    //     );
    // }

    // function repayLoan(uint256 _amountRepayed, uint16 _interestRateMode)
    //     external
    // {
    //     require(
    //         _amountRepayed <= borrowAmount,
    //         "amount exceeds borrowed token"
    //     );
    //     interestRateMode = _interestRateMode;
    //     lendingPool.repay(
    //         MyToken1,
    //         _amountRepayed,
    //         _interestRateMode,
    //         onBehalfOf
    //     );
    // }

    // function swapBorrowRate(uint16 _interestRateMode) external {
    //     interestRateMode = _interestRateMode;
    //     lendingPool.swapBorrowRateMode(onBehalfOf, interestRateMode);
    // }

    // function setUserUseReserveCollateral(bool _useAsCollateral) external {
    //     require(
    //         max_amount_borrow <= borrowAmount,
    //         "Amount exceeds borrowing limit"
    //     );
    //     _useAsCollateral = useAsCollateral;
    //     lendingPool.setUserUseReserveAsCollateral(onBehalfOf, _useAsCollateral);
    // }

    // function totalBalanceOfContract() public view returns (uint256) {
    //     return address(this).balance;
    // }

    // function onLiquidityCall(uint256 _collateralFactor, uint256 _debtToCover)
    //     external
    // {
    //     uint256 healthFactor = (amount * _collateralFactor) / borrowAmount;
    //     require(healthFactor < 1, "health factor is greater than 1");
    //     lendingPool.liquidationCall(
    //         onBehalfOf,
    //         MyToken1,
    //         onBehalfOf,
    //         _debtToCover,
    //         true
    //     );
    // }

    // function implementFlash() external {
    //     lendingPool.flashLoan();
    // }
}
