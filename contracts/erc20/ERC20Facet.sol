// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@moonstream/contracts/moonstream/ERC20WithCommonStorage.sol";
import "@moonstream/contracts/moonstream/LibERC20.sol";
import "@moonstream/contracts/diamond/libraries/LibDiamond.sol";

/*
    Implementation of Erc20 with Diamond storage with some modifications
    https://github.com/bugout-dev/dao/blob/main/contracts/moonstream/ERC20WithCommonStorage.sol
 */
contract ERC20Facet is ERC20WithCommonStorage {
    constructor() {}

    function contractController() external view returns (address) {
        return LibERC20.erc20Storage().controller;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        require(
            recipient != address(this),
            "ERC20Facet: You can't send UNIM to the contract itself. In order to burn, use burn()"
        );
        super.transferFrom(sender, recipient, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(
            recipient != address(this),
            "ERC20Facet: You can't send UNIM to the contract itself. In order to burn, use burn()"
        );
        super.transfer(recipient, amount);
        return true;
    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 currentAllowance = allowance(account, _msgSender());
        require(
            currentAllowance >= amount,
            "ERC20Facet: burn amount exceeds allowance"
        );
        unchecked {
            _approve(account, _msgSender(), currentAllowance - amount);
        }
        _burn(account, amount);
    }

    function mint(address account, uint256 amount) external {
        LibERC20.enforceIsController();
        _mint(account, amount);
    }
}
