// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/pool/Pool.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/pool/L2Pool.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/configuration/PoolAddressesProvider.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/interfaces/IFlashLoanReceiver.sol";
import "https://github.com/soliditylabs/ERC20-Permit/blob/main/contracts/IERC2612Permit.sol";

contract AaveIntegration_v3 {
    PoolAddressesProvider provider =
        PoolAddressesProvider(
            address(0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A)
        );
    Pool poolAddress = Pool(provider.getPool());
    address public pool_Address = provider.getPool();

    address public aave = 0x88541670E55cC00bEEFD87eB59EDd1b7C511AC9a;
    uint16 public refferal = 0;

    function supplyToken(
        address _asset,
        uint256 _amount,
        address _onBehalfOf
    ) external {
        IERC20(aave).transferFrom(msg.sender, address(this), _amount);
        IERC20(aave).approve(provider.getPool(), _amount);
        IPool(provider.getPool()).supply(
            _asset,
            _amount,
            _onBehalfOf,
            refferal
        );
    }

    function withdrawToken(uint256 _amount, address _to) external {
        IPool(provider.getPool()).withdraw(aave, _amount, _to);
    }

    function setReserveAsCollateral() external {
        IPool(provider.getPool()).setUserUseReserveAsCollateral(aave, true);
    }

    function borrowToken(
        uint256 _amount,
        uint256 _interestRateMode,
        address _onBehalfOf,
        address _asset
    ) external {
        IPool(provider.getPool()).borrow(
            _asset,
            _amount,
            _interestRateMode,
            refferal,
            _onBehalfOf
        );
    }

    function swapBorrowRateOfToken(address _asset, uint256 _rateMode) external {
        IPool(provider.getPool()).swapBorrowRateMode(_asset, _rateMode);
    }

    function repayTokens(
        address _asset,
        uint256 _amount,
        uint256 _rateMode,
        address _onBehalfOf
    ) external {
        IERC20(_asset).approve(_asset, _amount);
        IPool(provider.getPool()).repay(
            _asset,
            _amount,
            _rateMode,
            _onBehalfOf
        );
    }

    function rebalanceToken(address _asset, address _user) external {
        IPool(provider.getPool()).rebalanceStableBorrowRate(_asset, _user);
    }

    function liquidationCallToken(
        address _collateral,
        address _debt,
        address _user,
        uint256 _debtToCover,
        bool _receiveAToken
    ) external {
        IERC20(_collateral).transferFrom(_user, address(this), _debtToCover);
        IERC20(_collateral).approve(provider.getPool(), _debtToCover);
        IPool(provider.getPool()).liquidationCall(
            _collateral,
            _debt,
            _user,
            _debtToCover,
            _receiveAToken
        );
    }

    function flashLoanSimpleImplementations(
        address _receiverAddress,
        address _asset,
        uint256 _amount
    ) external {
        bytes memory _params = bytes("");
        require(
            IERC20(_asset).balanceOf(_asset) > (_amount * 2) / 100,
            "insufficient funds"
        );
        IPool(provider.getPool()).flashLoanSimple(
            _receiverAddress,
            _asset,
            _amount,
            _params,
            refferal
        );
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        IERC20(asset).approve(provider.getPool(), amount + premium);
        return true;
    }

    function flashLoanImplementation(
        address _receiverAddress,
        address[] memory _assets,
        uint256[] memory _amounts,
        uint256[] memory interestRateModes,
        address onBehalfOf,
        // bytes calldata params,
        uint16 referralCode
    ) external {
        bytes memory _params = bytes("");
        for (uint256 i = 0; i < _amounts.length; i++) {
            require(
                IERC20(_assets[i]).balanceOf(_assets[i]) >
                    (_amounts[i] * 2) / 100,
                "isufficient funds"
            );
        }
        IPool(provider.getPool()).flashLoan(
            _receiverAddress,
            _assets,
            _amounts,
            interestRateModes,
            onBehalfOf,
            _params,
            referralCode
        );
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool) {
        for (uint256 i = 0; i < amounts.length; i++) {
            IERC20(assets[i]).approve(
                provider.getPool(),
                amounts[i] + premiums[i]
            );
        }
        return true;
    }

    function supplyPermitTokens(
        address _asset,
        address _onBehalfOf,
        uint256 _amount,
        uint256 _deadline,
        uint8 _permitV,
        bytes32 _permitR,
        bytes32 _permitS
    ) external {
        IPool(provider.getPool()).supplyWithPermit(
            _asset,
            _amount,
            _onBehalfOf,
            refferal,
            _deadline,
            _permitV,
            _permitR,
            _permitS
        );
    }

    function mintToTreasuryToken(address[] calldata assets) external {
        for (uint256 i = 0; i < assets.length; i++) {
            IERC20(assets[i]).approve(
                assets[i],
                IERC20(assets[i]).balanceOf(assets[i])
            );
        }

        IPool(provider.getPool()).mintToTreasury(assets);
    }

    function repayAToken(
        address _asset,
        uint256 _amount,
        uint256 _interestRateMode
    ) external {
        IPool(provider.getPool()).repayWithATokens(
            _asset,
            _amount,
            _interestRateMode
        );
    }

    function userMode(uint8 _categoryId) external {
        IPool(provider.getPool()).setUserEMode(_categoryId);
    }

    function mintUnbackedToken(
        address _asset,
        uint256 _amount,
        address _onBehalfOf,
        uint16 _referralCode
    ) external {
        IPool(provider.getPool()).mintUnbacked(
            _asset,
            _amount,
            _onBehalfOf,
            _referralCode
        );
    }
}
