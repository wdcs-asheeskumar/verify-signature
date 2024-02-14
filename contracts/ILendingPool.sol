//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

interface ILendingPool {
  function deposit(
    address asset,
    uint256 amount,
    address onBehalfOf,
    uint16 referralCode
  ) external;


    function borrow(
        address _reserve,
        uint256 _amount,
        uint256 _interestRateMode,
        uint16 _referralCode,
        address onBehalOf
    ) external payable;

    function repay(
        address _reserve,
        uint256 _amount,
        address payable _onBehalfOf
    ) external returns (uint256);

    function getReserveData(address _reserve)
        external
        view
        returns (
            uint256 totalLiquidity,
            uint256 availableLiquidity,
            uint256 totalBorrowsStable,
            uint256 totalBorrowsVariable,
            uint256 liquidityRate,
            uint256 variableBorrowRate,
            uint256 stableBorrowRate,
            uint256 averageStableBorrowRate,
            uint256 utilizationRate,
            uint256 liquidationIndex,
            uint256 variableBorrowIndex,
            address atokenAddress,
            uint40 lastUpdateTimestamp
        );

    function liquidationCall(
        address _collateral,
        address _reserve,
        address _user,
        uint256 _purchaseAmount,
        bool _receiveAToken
    )
        external
        payable;
        
    function withdraw(
    address asset,
    uint256 amount,
    address to
  ) external returns (uint256);
}
