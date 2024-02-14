//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./ILendingPoolAddressProvider.sol";
import "./ILendingPool.sol";

contract Liquidator {
    address constant aaveEthAddress =
        0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address constant lendingPoolAddressProvider =
        0x24a42fD28C976A61Df5D00D0599C34c4f90748c8;

    function myLiquidationFunction(
        address _collateral,
        address _reserve,
        address _user,
        uint256 _purchaseAmount,
        bool _receiveaToken
    ) external {
        ILendingPoolAddressesProvider addressProvider = ILendingPoolAddressesProvider(
                lendingPoolAddressProvider
            );

        if (_reserve != aaveEthAddress) {
            require(
                IERC20(_reserve).approve(
                    addressProvider.getLendingPoolCore(),
                    _purchaseAmount
                ),
                "Approval error"
            );
        }

        ILendingPool lendingPool = ILendingPool(
            addressProvider.getLendingPool()
        );

        lendingPool.liquidationCall{
            value: (_reserve == aaveEthAddress ? _purchaseAmount : 0)
        }(_collateral, _reserve, _user, _purchaseAmount, _receiveaToken);
    }
}
