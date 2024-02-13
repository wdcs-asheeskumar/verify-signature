// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/pool/Pool.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/pool/L2Pool.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol";

contract AaveIntegration_v3 {
    PoolAddressesProvider provider =
        PoolAddressesProvider(
            address(0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A)
        );
    Pool poolAddress = Pool(provider.getPool());
    address public pool_Address = provider.getPool();

    address public aave = 0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a;
    uint16 public refferal = 0;

    function supplyToken(uint256 _amount, address _onBehalfOf) external {
        IERC20(aave).transferFrom(msg.sender, address(this), _amount);
        IERC20(aave).approve(provider.getPool(), _amount);
        IPool(provider.getPool()).supply(aave, _amount, _onBehalfOf, refferal);
    }

    function withdrawToken(uint256 _amount, address _to) external {
        IPool(provider.getPool()).withdraw(aave, _amount, _to);
    }

    function setReserveAsCollateral() external {
        IPool(provider.getPool()).setUserUseReserveAsCollateral(aave, true);
    }

    function borrowToken(uint _amount, uint _interestRateMode, address _onBehalfOf, address _asset) external {
        IPool(provider.getPool()).borrow(
            _asset, 
            _amount,
            _interestRateMode,
            refferal,
            _onBehalfOf
            );
    }

    function swapBorrowRateOfToken(address _asset, uint _rateMode) external {
        IPool(provider.getPool()).swapBorrowRateMode(
            _asset,
            _rateMode
        );
    }

    function repayTokens(
        address _asset, 
        uint256 _amount, 
        uint256 _rateMode, 
        address _onBehalfOf
        ) external {
        IERC20(_asset).approve(provider.getPool(), _amount);
        IPool(provider.getPool()).repay(
            _asset,
            _amount,
            _rateMode,
            _onBehalfOf
        );
    }

    function rebalanceToken(
        address _asset, 
        address _user
        ) external {
        IPool(provider.getPool()).rebalanceStableBorrowRate(
            _asset,
            _user
        );
    }

}
