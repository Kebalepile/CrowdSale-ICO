// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Ownable.sol";
import "./KCoin.sol";

contract CrowdFund is Ownable {
    uint256 public startTime;
    uint256 public endTime;
    uint256 public weiTokenPrice; //price of token being sold
    uint256 public weiInvestmentObjective; //minmum capital raise target.

    mapping(address => uint256) public investmentAmount;
    uint256 public investmentReceived; //total Ether received from investors
    uint256 public investmentRefunded; //total Ether refunded to investors.

    bool public isFinalized; //inidacted if crowdfunding is finalized
    bool public isRefundingAllowed; //indicates wheather refunding is allowed.

    KCoin public crowdSaleToken;

    constructor(
        uint256 _startTime,
        uint256 _endTime,
        uint256 _weiTokenPrice,
        uint256 _etherInvestmentObject
    ) public {
        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestmentObjective = _etherInvestmentObject;
        crowdSaleToken = new KCoin(0);
        owner = msg.sender;
    }

    event LogInvestment(address indexed investor, uint256 value);
    event LogTokenAsignment(address investor, uint256 numTokens);

    function invest() public payable {
        require(isValidInvestmentValue(msg.value));

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmount[investor] += investment;
        investmentReceived += investment;

        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);
    }

    function isValidInvestmentValue(uint256 investment)
        internal
        pure
        returns (bool)
    {
        bool nonZeroInvestment = investment != 0;
        bool withinCrowdsalePeriod = true; //block.timestamp >= startTime &&
        // block.timestamp <= endTime;

        return nonZeroInvestment && withinCrowdsalePeriod;
    }

    function assignTokens(address beneficiary, uint256 amount) internal {
        uint256 numOfToken = calculateNumberOfToken(amount);
        crowdSaleToken.mint(beneficiary, numOfToken);
    }

    function calculateNumberOfToken(uint256 amount) internal view returns (uint256) {
        return amount / weiTokenPrice;
    }

    function finalize() public onlyOwner {
        if (isFinalized) revert();
        bool isCrowdsaleComplete = true; //block.timestamp > endTime;
        bool investmentObjectiveMet = investmentReceived >=
            weiInvestmentObjective;

        if (isCrowdsaleComplete) {
            if (investmentObjectiveMet) {
                crowdSaleToken.release();
            } else {
                isRefundingAllowed = true;
            }
            isFinalized = true;
        }
    }

    event Refund(address investor, uint256 value);

    function refund() public {
        if (!isRefundingAllowed) {
            revert();
        }
        address payable investor = msg.sender;
        uint256 investment = investmentAmount[investor];
        if (investment == 0) {
            revert();
        }
        investmentAmount[investor] = 0;
        investmentRefunded += investment;
        emit Refund(investor, investment);
        investor.transfer(investment);
    }
}
