// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC1967, ERC1967_PROXY_STORAGE_SLOT, ERC1822} from "./ERC1967Proxy.sol";

// ------------- errors

error OnlyProxyCallAllowed();
error DelegateCallNotAllowed();

/// @notice Minimal UUPSUpgrade
/// @author phaze (https://github.com/0xPhaze/proxies-with-immutable-args)
abstract contract UUPSUpgrade is ERC1967, ERC1822 {
    address private immutable __implementation = address(this);

    /* ------------- external ------------- */

    function upgradeToAndCall(address logic, bytes calldata data) external {
        _authorizeUpgrade();
        _upgradeToAndCall(logic, data);
    }

    /* ------------- view ------------- */

    function proxiableUUID() external view virtual override notDelegated returns (bytes32) {
        return ERC1967_PROXY_STORAGE_SLOT;
    }

    /* ------------- virtual ------------- */

    function _authorizeUpgrade() internal virtual;

    /* ------------- modifier ------------- */

    modifier onlyProxy() {
        if (address(this) == __implementation) revert OnlyProxyCallAllowed();
        _;
    }

    modifier notDelegated() {
        if (address(this) != __implementation) revert DelegateCallNotAllowed();
        _;
    }
}
