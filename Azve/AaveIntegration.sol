//SPDX-License-Identifier:MIT
pragma solidity ^0.6.0;
import "https://github.com/aave/protocol-v2/blob/master/contracts/protocol/lendingpool/LendingPool.sol";
import "https://github.com/aave/protocol-v2/blob/master/contracts/protocol/configuration/LendingPoolAddressesProvider.sol";
import "https://github.com/aave/protocol-v2/blob/master/contracts/interfaces/ICreditDelegationToken.sol";
import "https://github.com/aave/protocol-v2/blob/master/contracts/misc/AaveProtocolDataProvider.sol";

contract AaveIntegration {
    LendingPoolAddressesProvider provider =
        LendingPoolAddressesProvider(
            address(0x5E52dEc931FFb32f609681B8438A51c675cc232d)
        );
    LendingPool lendingPool = LendingPool(provider.getLendingPool());
    address public addLend = provider.getLendingPool();
    //Input variable
    address public aave = address(0x0B7a69d978DdA361Db5356D4Bd0206496aFbDD96);
    address public aAave = address(0x5fDF09EE06219f96EffE1b4CC47f44A630C5A358);
    uint16 public referral = 0;
    address public poolAddress = provider.getLendingPool();

    function depositTokens(uint256 amount) external {
        IERC20(aave).transferFrom(msg.sender, address(this), amount);
        IERC20(aave).approve(provider.getLendingPool(), amount);
        ILendingPool(provider.getLendingPool()).deposit(
            aave,
            amount,
            address(this),
            referral
        );
    }

    function withdrawTokens(uint256 amount) external {
        ILendingPool(provider.getLendingPool()).withdraw(
            aave,
            amount,
            address(this)
        );
    }

    function setReserveAsCollateral(address _aave) external {
        ILendingPool(provider.getLendingPool()).setUserUseReserveAsCollateral(
            _aave,
            true
        );
    }

    function borrowTokens(uint256 _amount, address _addr) external {
        // creditDelegationToken.approveDelegation(_addr, _amount2);
        ILendingPool(provider.getLendingPool()).borrow(
            _addr,
            _amount,
            1,
            referral,
            address(this)
        );
    }

    function repayTokens(
        uint256 _amount,
        uint256 _rateMode,
        address _addr,
        address _onBehalfOf
    ) external {
        IERC20(_addr).approve(provider.getLendingPool(), _amount);
        ILendingPool(provider.getLendingPool()).repay(
            _addr,
            _amount,
            _rateMode,
            _onBehalfOf
        );
    }

    function swapBorrowRateOfToken(uint256 _rateMode, address _asset) external {
        ILendingPool(provider.getLendingPool()).swapBorrowRateMode(
            _asset,
            _rateMode
        );
    }

    function liquidationCallForTokens(
        address _collateral,
        address _debt,
        address _user,
        uint256 _debtToCover,
        bool _receiveAToken
    ) external {
        IERC20(_debt).approve(provider.getLendingPool(), _debtToCover);
        ILendingPool(provider.getLendingPool()).liquidationCall(
            _collateral,
            _debt,
            _user,
            _debtToCover,
            _receiveAToken
        );
    }
}
