//SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "https://github.com/aave/protocol-v2/blob/master/contracts/protocol/configuration/LendingPoolAddressesProvider.sol";
import "https://github.com/aave/protocol-v2/blob/master/contracts/protocol/configuration/LendingPoolAddressesProvider.sol";

contract AaveIntegration {
    ILendingPoolAddressesProvider provider;
    ILendingPool lendingPool;
    address public aave;
    uint16 public referral;

    constructor(
        address _providerAddress,
        address _aaveAddress,
        uint16 _referral
    ) public {
        provider = ILendingPoolAddressesProvider(_providerAddress);
        lendingPool = ILendingPool(provider.getLendingPool());
        aave = _aaveAddress;
        referral = _referral;
    }

    function depositTokens(uint256 amount) external {
        IERC20(aave).transferFrom(msg.sender, address(this), amount);
        IERC20(aave).approve(address(lendingPool), amount);
        lendingPool.deposit(aave, amount, msg.sender, referral);
    }

    function withdrawTokens(uint256 amount) external {
        lendingPool.withdraw(aave, amount, msg.sender);
    }

    function setReserveAsCollateral(address _aave) external {
        lendingPool.setUserUseReserveAsCollateral(_aave, true);
    }

    function borrowTokens(uint256 _amount) external {
        lendingPool.borrow(aave, _amount, 1, referral, msg.sender);
    }
}
