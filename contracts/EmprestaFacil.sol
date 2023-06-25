//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EmprestaFacil is ERC20 {
    uint256 public constant INITIAL_SUPPLY = 100 * 10**18;
    uint256 public constant EMPF_TO_ETH = 100; // 1 EMPF = 0.001 ETH
    uint256 public constant LOAN_INTEREST = 10; // 10%
    uint256 public constant LOAN_FEE = 1; // 1% fee
    uint256 public constant LOAN_DURATION = 30 days;
    
    struct Loan {
        uint256 amount;
        uint256 dueDate;
        bool isPaid;
        address borrower;
        address lender;
    }

    Loan[] public loans;

    mapping(address => bool) public registeredUsers;
    mapping(address => bool) public blockedAccounts;

    event UserRegistered(address indexed user);
    event LoanCreated(uint256 loanId, address indexed borrower, address indexed lender, uint256 amount);
    event LoanPaid(uint256 loanId);

    constructor() ERC20("Empresta Facil", "EMPF") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function register() public {
        require(!registeredUsers[msg.sender], "User already registered");
        registeredUsers[msg.sender] = true;
        _mint(msg.sender, 100 * 10**18); // Give 100 EMPF to the user
        emit UserRegistered(msg.sender);
    }

    function requestLoan(address lender, uint256 amount) public {
        require(registeredUsers[msg.sender], "User not registered");
        require(balanceOf(lender) >= amount, "Lender does not have enough tokens");

        // transfer the tokens to the borrower
        transferFrom(lender, msg.sender, amount);

        // Create the loan
        loans.push(Loan({
            amount: amount,
            dueDate: block.timestamp + LOAN_DURATION,
            isPaid: false,
            borrower: msg.sender,
            lender: lender
        }));

        emit LoanCreated(loans.length - 1, msg.sender, lender, amount);
    }
    
    function payLoan(uint256 loanId) public payable {
        Loan storage loan = loans[loanId];

        require(msg.sender == loan.borrower, "Only the borrower can pay the loan");
        require(!loan.isPaid, "Loan is already paid");
        require(balanceOf(msg.sender) >= loan.amount * (100 + LOAN_INTEREST) / 100, "Borrower does not have enough tokens");

        // Transfer the tokens to the lender
        transferFrom(msg.sender, loan.lender, loan.amount * (100 + LOAN_INTEREST) / 100);

        // Mark the loan as paid
        loan.isPaid = true;

        emit LoanPaid(loanId);
    }

    function redeem(uint256 amount) public {
        uint256 empf_TO_ETH = 1000; // 1 EMPF = 0.001 ETH
        uint256 ethAmount = (amount * empf_TO_ETH) / 10**18;
        require(balanceOf(msg.sender) >= amount, "Insufficient empf balance");
        require(address(this).balance >= ethAmount, "Insufficient ETH balance");

        _burn(msg.sender, amount);

        (bool success, ) = msg.sender.call{value: ethAmount}("");
        require(success, "Transfer failed");
    }

    function checkOverdueLoans() public {
    for (uint i = 0; i < loans.length; i++) {
        if (!loans[i].isPaid && loans[i].dueDate < block.timestamp) {
            blockedAccounts[loans[i].borrower] = true;
            }
        }   
    }

    function penalizeBorrower(address borrower) internal {
        blockedAccounts[borrower] = true;
    }
    
function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
    require(!blockedAccounts[sender], "Sender account is blocked");
    require(!blockedAccounts[recipient], "Recipient account is blocked");
    return super.transferFrom(sender, recipient, amount);
}


    function transferempfToEth(uint256 empfAmount) public pure returns (uint256) {
        uint256 empf_TO_ETH = 1000; // 1 EMPF = 0.001 ETH
        return (empfAmount * empf_TO_ETH) / 10**18;
        }
    

    function tokenInfo() public view returns (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) {
        return (this.name(), this.symbol(), this.decimals(), this.totalSupply());
    }

    receive() external payable {}
}